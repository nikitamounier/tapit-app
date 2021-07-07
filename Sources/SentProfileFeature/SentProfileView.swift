import ComposableArchitecture
import FeedbackGeneratorClient
import OpenSocialClient
import SharedModels

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
    
    public init(
        feedbackGenerator: FeedbackGeneratorClient,
        openSocial: OpenSocialClient,
        openAppSettings: @escaping () -> Void
    ) {
        self.feedbackGenerator = feedbackGenerator
        self.openSocial = openSocial
        self.openAppSettings = openAppSettings
    }
}

public let sentProfileReducer = Reducer<SentProfile, SentProfileAction, SentProfileEnvironment>.combine(
    openSocialReducer.pullback(
        state: \.openSocialFailed,
        action: /SentProfileAction.self,
        environment: { $0 }
    ),
    
    Reducer { profile, action, env in
        switch action {
        case let .setName(name):
            profile.name = name
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


