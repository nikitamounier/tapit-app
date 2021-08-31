import Combine
import ComposableArchitecture
import FeedbackGeneratorClient
import ExpirationClient
import IdentifiedCollections
import NonEmpty
import OpenSocialClient
import OrderedCollections
import Prelude
@_exported import SentProfileFeature
import SharedModels
import SwiftHelpers
import SwiftUI

public struct HistoryState: Equatable {
    public var profiles: IdentifiedArrayOf<SentProfile>
    public var selectedProfile: SentProfile.ID?
    
    public var viewingOrder: ViewingOrder
    
    public var categories: NonEmptyArray<ProfilesCategory>
    public var currentCategory: ProfilesCategory.ID
    public var showCategoryCreation: Bool
    
    public var isSearching: Bool
    public var currentSearch: String
    public var searchResults: [SentProfile.ID]
    
    public enum ViewingOrder: Codable {
        case newestToOldest
        case oldestToNewest
        case alphabetical
    }
    
    public init(
        profiles: IdentifiedArrayOf<SentProfile> = [],
        selectedProfile: SentProfile.ID? = nil,
        viewingOrder: ViewingOrder = .newestToOldest,
        categories: NonEmptyArray<ProfilesCategory> = .init(.all),
        currentCategory: ProfilesCategory.ID = "all",
        showCategoryCreation: Bool = false,
        isSearching: Bool = false,
        currentSearch: String = "",
        searchResults: [SentProfile.ID] = []
    ) {
        self.profiles = profiles
        self.selectedProfile = selectedProfile
        self.viewingOrder = viewingOrder
        self.categories = categories
        self.currentCategory = currentCategory
        self.showCategoryCreation = showCategoryCreation
        self.isSearching = isSearching
        self.currentSearch = currentSearch
        self.searchResults = searchResults
    }
}

public enum HistoryAction: Equatable {
    case sentProfile(id: SentProfile.ID, action: SentProfileAction)
    
    case setNavigation(id: SentProfile.ID?)
    
    case goToCategory(ProfilesCategory.ID)
    case createCategoryButtonTapped
    case createCategory(name: String, profileIDs: Set<SentProfile.ID>)
    case removeCategory(index: Int)
    case removeCategoryCreation
    case moveCategory(from: Int, toOffset: Int)
    
    case changeViewingOrder(to: HistoryState.ViewingOrder)
    
    case searchBarTapped
    case searchInput(text: String)
    case searchResponse(input: String)
    case cancelSearchTapped
}

public struct HistoryEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var feedbackGenerator: FeedbackGeneratorClient
    public var isSentProfileExpired: ExpirationClient
    public var openSocial: OpenSocialClient
    public var openAppSettings: () -> Void
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        feedbackGenerator: FeedbackGeneratorClient,
        isSentProfileExpired: ExpirationClient,
        openSocial: OpenSocialClient,
        openAppSettings: @escaping () -> Void
    ) {
        self.mainQueue = mainQueue
        self.feedbackGenerator = feedbackGenerator
        self.isSentProfileExpired = isSentProfileExpired
        self.openSocial = openSocial
        self.openAppSettings = openAppSettings
    }
}

public let historyReducer = Reducer<HistoryState, HistoryAction, HistoryEnvironment>.combine(
    sentProfileReducer.forEach(
        state: \.profiles,
        action: .sentProfile,
        environment: {
            SentProfileEnvironment(
                feedbackGenerator: $0.feedbackGenerator,
                openSocial: $0.openSocial,
                openAppSettings: $0.openAppSettings
            )
        }
    ),
    
    Reducer { state, action, env in
        struct SearchID: Hashable {}
        
        switch action {
        case let .setNavigation(id: id):
            state.selectedProfile = id
            return .none
            
        case let .sentProfile(id: id, action: .removeSentProfile):
            state.profiles.remove(id: id)
            return .none
            
        case let .sentProfile(id: id, action: .addToCategory(category)):
            state.categories
                .firstIndex { $0.id == category.id }
                .map { state.categories[$0].add(id) }
                .fireAndForget()
            return .none
            
        case let .sentProfile(id: id, action: .removeFromCategory(category)):
            state.categories
                .firstIndex { $0 == category }
                .map { state.categories[$0].remove(id) }
                .fireAndForget()
            return .none
            
        case .sentProfile:
            return .none
            
        case let .goToCategory(id):
            state.currentCategory = id
            return .none
            
        case .createCategoryButtonTapped:
            state.showCategoryCreation = true
            return .none
            
        case let .createCategory(name: name, profileIDs: profileIDs):
            state.categories.append(.custom(name: name, profileIDs: profileIDs))
            return .none
            
        case let .removeCategory(index: index):
            guard index != 0 else { return .none }
            state.categories.remove(at: index)
            return .none
            
        case .removeCategoryCreation:
            state.showCategoryCreation = false
            return .none
            
        case let .moveCategory(from: source, toOffset: destination):
            guard source != 0 && destination != 0 else { return .none }
            state.categories.move(
                fromOffsets: IndexSet(integer: source),
                toOffset: destination > source ? destination + 1 : destination
            )
            return .none
            
        case let .changeViewingOrder(to: order):
            state.viewingOrder = order
            return .none
            
        case .searchBarTapped:
            state.isSearching = true
            return .none
            
        case let .searchInput(text: text):
            state.currentSearch = text
            return Effect(value: .searchResponse(input: text))
                .debounce(id: SearchID(), for: 0.5, scheduler: env.mainQueue)
                .removeDuplicates()
                .eraseToEffect()
 
        case let .searchResponse(input: input):
            enum SearchResult: Hashable, CaseIterable {
                case completeMatch
                case firstWordMatch
                case notFirstWordMatch
                case firstWordContains
                case notFirstWordContains
                case socialContains
            }
            
            let resultBuckets: [SearchResult: [SentProfile.ID]] = state.profiles
                .reduce(
                    into: Dictionary(uniqueKeysWithValues: SearchResult.allCases.map { ($0, []) })
                ) { result, profile in
                    if input.isEmpty {
                        return
                    }
                    
                    if input == profile.name {
                        result[.completeMatch]!.append(profile.id)
                        return
                    }
                    
                    let words = input
                        .localizedLowercase
                        .split(separator: " ")
                    
                    let profileWords = profile.name
                        .localizedLowercase
                        .split(separator: " ")
                  
                  // john, doe
                  // johhny, appleseed
                    
                    if words[0].localizedLowercase == profileWords[0].localizedLowercase {
                        result[.firstWordMatch]!.append(profile.id)
                        return
                    }
                  
                    if profile.name.localizedCaseInsensitiveContains(words[0]) {
                        result[.firstWordContains]!.append(profile.id)
                        return
                    }
                    
                    for (index, word) in words.indexed() {
                        if profileWords.contains(word), index != 0 {
                            result[.notFirstWordMatch]!.append(profile.id)
                            break
                            
                        } else if profile.name.localizedCaseInsensitiveContains(word), index != 0 {
                            result[.notFirstWordContains]!.append(profile.id)
                            break
                            
                            
                        } else if profile.socials.contains(where: { social in
                            switch social {
                            case .instagram(let urlComp), .snapchat(let urlComp), .twitter(let urlComp), .facebook(let urlComp), .reddit(let urlComp), .tikTok(let urlComp), .weChat(let urlComp), .github(let urlComp), .linkedIn(let urlComp):
                                return urlComp.path.localizedCaseInsensitiveContains(word)
                                
                            case let .address(address):
                                return false
                                
                            case let .email(email):
                                return email.rawValue.localizedCaseInsensitiveContains(word)
                                
                            case let .phone(phone):
                                return phone.numberString.localizedCaseInsensitiveContains(word)
                            }
                        }) {
                            result[.socialContains]!.append(profile.id)
                        }
                    }
                }
            
            state.searchResults = SearchResult.allCases
                .reduce(into: [SentProfile.ID]()) { array, classification in
                    array.append(contentsOf: resultBuckets[classification] ?? [])
                }
            return .none
            
        case .cancelSearchTapped:
            state.isSearching = false
            state.currentSearch = ""
            state.searchResults = []
            return .cancel(id: SearchID())
        }
    }
)

public struct HistoryView: View {
    struct ViewState: Equatable {
        var profiles: IdentifiedArrayOf<SentProfile>
        var selectedProfile: SentProfile.ID?
        var categories: NonEmptyArray<ProfilesCategory>
        
        init(state: HistoryState) {
            self.profiles = state.profiles
            self.selectedProfile = state.selectedProfile
            self.categories = state.categories
        }
    }
    
    let store: Store<HistoryState, HistoryAction>
    @ObservedObject var viewStore: ViewStore<ViewState, HistoryAction>
    
    public init(store: Store<HistoryState, HistoryAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: ViewState.init))
    }
    
    public var body: some View {
        NavigationView {
            List {
                ForEachStore(
                    store.scope(
                        state: \.profiles,
                        action: HistoryAction.sentProfile
                    )
                ) { sentProfileStore in
                    WithViewStore(sentProfileStore) { viewStore in
                        NavigationLink(
                            destination: Text(viewStore.name),
                            tag: viewStore.id,
                            selection: self.viewStore.binding(
                                get: \.selectedProfile,
                                send: HistoryAction.setNavigation
                            )
                        ) {
                            Text(viewStore.name)
                        }
                    }
                }
            }
            .navigationTitle(Text("History"))
        }
    }
}

@available(iOSApplicationExtension, unavailable)
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(
            store: Store(
                initialState: HistoryState(),
                reducer: historyReducer,
                environment: HistoryEnvironment(
                    mainQueue: .main,
                    feedbackGenerator: .live,
                    isSentProfileExpired: .live,
                    openSocial: .live,
                    openAppSettings: {}
                )
            )
        )
    }
}

extension CasePath where Root == HistoryAction, Value == (SentProfile.ID, SentProfileAction) {
    static let sentProfile = Self(
        embed: HistoryAction.sentProfile,
        extract: {
            guard case let .sentProfile(id: id, action: action) = $0 else { return nil }
            return (id, action)
        }
    )
}
