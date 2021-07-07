import ComposableArchitecture
import FeedbackGeneratorClient
import OpenSocialClient
import SharedModels

public struct SentProfileState: Equatable {
    public var profile: SentProfile
    public var profileCategories: [ProfilesCategory]
    public var openSocialFailedAlert: AlertState<AlertAction>?
}

public enum SentProfileAction: Equatable {
    case alert(AlertAction)
    case setName(to: String)
    case open(Social, OpenSocialClient.Option?)
    case addToCategories([ProfilesCategory])
    case removeFromCategories([ProfilesCategory])
    case removeSentProfile
}

public struct SentProfileEnvironment {
    public var feedbackGenerator: FeedbackGeneratorClient
    public var openSocial: OpenSocialClient
    public var openAppSettings: () -> Void
}

public let sentProfileReducer = Reducer<SentProfileState, SentProfileAction, SentProfileEnvironment>.combine(
    openSocialReducer.pullback(
        state: \.openSocialFailedAlert,
        action: /SentProfileAction.self,
        environment: { $0 }
    ),
    
    Reducer { state, action, env in
        switch action {
        case let .setName(name):
            state.profile.name = name
            return .none
            
        case let .addToCategories(categories):
            categories.forEach { category in
                
            }
            return .none
            
        case let .removeFromCategories(categories):
            categories.forEach { category in
                
            }
            return .none
            
        case .removeSentProfile:
            return .none
            
        case .alert:
            return .none
            
        case .open:
            return .none
        }
    }
)


