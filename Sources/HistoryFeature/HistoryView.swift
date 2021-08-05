import ComposableArchitecture
import FeedbackGeneratorClient
import ExpirationClient
import IdentifiedCollections
import NonEmpty
import OpenSocialClient
import SentProfileFeature
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
        showCategoryCreation: Bool = false
    ) {
        self.profiles = profiles
        self.selectedProfile = selectedProfile
        self.viewingOrder = viewingOrder
        self.categories = categories
        self.currentCategory = currentCategory
        self.showCategoryCreation = showCategoryCreation
    }
}

public enum HistoryAction: Equatable {
    case setNavigation(id: SentProfile.ID?)
    case createCategoryButtonTapped
    case createCategory(name: String, profileIDs: Set<SentProfile.ID>)
    case removeCategory(index: Int)
    case moveCategory(from: Int, to: Int)
    case changeViewingOrder(to: HistoryState.ViewingOrder)
    
    case sentProfile(id: SentProfile.ID, action: SentProfileAction)
}

public struct HistoryEnvironment {
    public var feedbackGenerator: FeedbackGeneratorClient
    public var isSentProfileExpired: ExpirationClient
    public var openSocial: OpenSocialClient
    public var openAppSettings: () -> Void
    
    public init(
        feedbackGenerator: FeedbackGeneratorClient,
        isSentProfileExpired: ExpirationClient,
        openSocial: OpenSocialClient,
        openAppSettings: @escaping () -> Void
    ) {
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
        switch action {
        case let .setNavigation(id: id):
            state.selectedProfile = id
            return .none
            
        case let .sentProfile(id: id, action: .removeSentProfile):
            state.profiles.remove(id: id)
            return .none
            
        case let .sentProfile(id: id, action: .addToCategory(category)):
            state.categories
                .firstIndex { $0 == category }
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
            
        case let .moveCategory(from: sourceIndex, to: destinationIndex):
            state.categories.move(fromOffsets: IndexSet(integer: sourceIndex), toOffset: destinationIndex)
            return .none
            
        case let .changeViewingOrder(to: order):
            state.viewingOrder = order
            return .none
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
                initialState: HistoryState(
                    profiles: .init(uniqueElements: Array(repeating: SentProfile(profile: UserProfile(id: .init(), name: "John Appleseed", profileImage: .mock, socials: .mock), sendDate: .oneWeekAgo, expirationInterval: Days(10)), count: 100)),
                    selectedProfile: nil,
                    categories: .init(.all)),
                reducer: historyReducer,
                environment: HistoryEnvironment(
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

