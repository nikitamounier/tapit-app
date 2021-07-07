import ComposableArchitecture
import FeedbackGeneratorClient
import OpenSocialClient
import SentProfileFeature
import SharedModels

public struct HistoryState: Equatable {
    public var profiles: IdentifiedArray<SentProfile>
    public var categories: [ProfilesCategory]
}

public enum HistoryAction: Equatable {
    case sentProfile(id: SentProfile.ID, action: SentProfileAction)
    
}

public struct HistoryEnvironment {
    public var feedbackGenerator: FeedbackGeneratorClient
    public var openSocial: OpenSocialClient
    public var openAppSettings: () -> Void
}

public let historyReducer = Reducer<HistoryState, HistoryAction, HistoryEnvironment>.combine(
    sentProfileReducer.forEach(
        state: \.profiles,
        action: /HistoryAction.sentProfile,
        environment: {
            SentProfileEnvironment(
                feedbackGenerator: $0.feedbackGenerator,
                openSocial: $0.openSocial,
                openAppSettings: $0.openAppSettings
            )
        }
    )
)
