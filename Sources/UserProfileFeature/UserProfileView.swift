import ComposableArchitecture
import Foundation
import ImageLibraryClient
import OpenSocialClient
import OpenSocialFeature
import PFPEditFeature
import SharedModels
import SpringboardFeature
import SwiftUI


public struct UserProfileState: Equatable {
    public var profile: UserProfile
    public var springboard: SpringboardState
    public var profilePictureEdit: PFPEditState?
    public var openSocial: OpenSocialState
    
    public init(
        profile: UserProfile,
        profilePictureEdit: PFPEditState? = nil,
        openSocial: OpenSocialState = .init(alert: nil)
    ) {
        self.profile = profile
        self.springboard = SpringboardState(items: profile.socials)
        self.profilePictureEdit = profilePictureEdit
        self.openSocial = openSocial
    }
}

public enum UserProfileAction: Equatable {
    case springboard(SpringboardAction)
    case profilePictureEdit(PFPEditAction)
    case openSocial(OpenSocialAction)
    
    case profileImageTapped
    case startEditing
    case setName(to: String)
}

public struct UserProfileEnvironment {
    public var imageLibrary: ImageLibraryClient
    public var openSocial: OpenSocialClient
    public var feedbackGenerator: FeedbackGeneratorClient
    public var openAppSettings: () -> Void
}

public let userProfileReducer = Reducer<UserProfileState, UserProfileAction, UserProfileEnvironment>.combine(
    springBoardReducer
        .pullback(
            state: \.springboard,
            action: .springboard,
            environment: { _ in
                SpringboardEnvironment()
            }
        ),
    
    profilePictureEditReducer
        .optional()
        .pullback(
            state: \.profilePictureEdit,
            action: .profilePictureEdit,
            environment: {
                PFPEditEnvironment(
                    imageLibrary: $0.imageLibrary,
                    feedbackGenerator: $0.feedbackGenerator
                )
            }
        ),
    
    openSocialReducer
        .pullback(
            state: \.openSocial,
            action: .openSocial,
            environment: {
                OpenSocialEnvironment(
                    openSocial: $0.openSocial,
                    feedbackGenerator: $0.feedbackGenerator,
                    openAppSettings: $0.openAppSettings
                )
            }
        ),
    
    Reducer { state, action, env in
        switch action {
        case let .profileImageTapped:
            state.profilePictureEdit = PFPEditState(image: state.profile.profileImage)
            return Effect(value: .profilePictureEdit(.startEditing))
            
        case .startEditing:
            state.isEditing = true
            return .none
            
        case let .setName(to: name):
            state.profile.name = name
            return .none
            
        case let .springboard(.moveSocial(from: source, toOffset: destination)):
            state.profile.socials.move(
                fromOffsets: IndexSet(integer: source),
                toOffset: destination > source ? destination + 1 : destination
            )
            return .none
            
        case let .springboard(.removeSocial(index: index)):
            state.profile.socials.remove(at: index)
            return .none
            
        case .profilePictureEdit(.finished):
            state.profile.profileImage = state.profilePictureEdit!.profileImage
            state.profilePictureEdit = nil
            return .none
            
        case .springboard:
            return .none
            
        case .profilePictureEdit:
            return .none
            
        case .openSocial:
            return .none
        }
    }
)

public struct UserProfileView: View {
    let store: Store<UserProfileState, UserProfileAction>
    @ObservedObject var viewStore: ViewStore<UserProfileState, UserProfileAction>
    
    public init(store: Store<UserProfileState, UserProfileAction>) {
        self.store = store
        self.viewStore = store
    }
    
    public var body: some View {
        EmptyView()
    }
}

extension CasePath where Root == UserProfileAction, Value == SpringboardAction {
    static let springboard = Self(
        embed: UserProfileAction.springboard,
        extract: {
            guard case let .springboard(action) = $0 else { return nil }
            return action
        }
    )
}

extension CasePath where Root == UserProfileAction, Value == PFPEditAction {
    static let profilePictureEdit = Self(
        embed: UserProfileAction.profilePictureEdit,
        extract: {
            guard case let .profilePictureEdit(action) = $0 else { return nil }
            return action
        }
    )
}

extension CasePath where Root == UserProfileAction, Value == OpenSocialAction {
    static let openSocial = Self(
        embed: UserProfileAction.openSocial,
        extract: {
            guard case let .openSocial(action) = $0 else { return nil }
            return action
        }
    )
}
