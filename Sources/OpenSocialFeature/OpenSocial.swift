import CombineHelpers
import ComposableArchitecture
import FeedbackGeneratorClient
import OpenSocialClient
import SharedModels

public struct OpenSocialState: Equatable {
    public var alert: AlertState<OpenSocialAction.AlertAction>?
    
    public init(alert: AlertState<OpenSocialAction.AlertAction>?) {
        self.alert = alert
    }
}

public enum OpenSocialAction: Equatable {
    case open(Social, OpenSocialClient.Option?)
    case alert(AlertAction)
    
    public enum AlertAction: Equatable {
        case cancelButtonTapped
        case confirmButtonTapped
        case openAppSettings
        
        case failedToOpenURL
        case failedToOpenAddress
        case failedToOpenEmailAddress
        case didNotHaveAuthorization
        case failedToOpenPhone
    }
}

public struct OpenSocialEnvironment {
    public var openSocial: OpenSocialClient
    public var feedbackGenerator: FeedbackGeneratorClient
    public var openAppSettings: () -> Void
    
    public init(
        openSocial: OpenSocialClient,
        feedbackGenerator: FeedbackGeneratorClient,
        openAppSettings: @escaping () -> Void
    ) {
        self.openSocial = openSocial
        self.feedbackGenerator = feedbackGenerator
        self.openAppSettings = openAppSettings
    }
}

public let openSocialReducer = Reducer<OpenSocialState, OpenSocialAction, OpenSocialEnvironment> { state, action, env in
    switch action {
    case let .open(social, option):
        let effect: Effect<Result<OpenSocialClient.OpenEvent, OpenSocialClient.OpenError>, Never>
        
        switch social {
        case .instagram, .snapchat, .twitter, .facebook, .reddit, .tikTok, .weChat, .github, .linkedIn, .address, .email:
            effect = env.openSocial
                .open(social, option: nil)
                .catchToEffect()
        case .phone:
            effect = env.openSocial
                .open(social, option: option)
                .catchToEffect()
        }
        
        return effect
            .map { result -> OpenSocialAction in
                switch result {
                case .success:
                    return nil
                    
                case let .failure(error):
                    switch error {
                    case .components(.failedConvertingComponentsToURL), .components(.failedOpeningURL):
                        return .alert(.failedToOpenURL)
                        
                    case .maps(.failedOpeningMaps):
                        return .alert(.failedToOpenAddress)
                        
                    case .email(.failedConvertingEmailToURL):
                        return .alert(.failedToOpenEmailAddress)
                        
                    case .phone(.failedHavingContactsAuthorization):
                        return .alert(.didNotHaveAuthorization)
                        
                    case .phone(.failedConvertingPhoneToURL), .phone(.failedOpeningPhoneURL):
                        return .alert(.failedToOpenPhone)
                    }
                }
            }
            .compactMap(\.self)
            .merge(with: env.feedbackGenerator.notificationOccurred(.error).fireAndForget())
            .eraseToEffect()
        
    case let .alert(alertAction):
        switch alertAction {
        case .cancelButtonTapped, .confirmButtonTapped:
            state.alert = nil
            return .none
            
        case .openAppSettings:
            return .fireAndForget(env.openAppSettings)
            
        case .failedToOpenURL:
            state.alert = .init(
                title: TextState("Failed to open URL"),
                message: TextState("Make sure you have the right username. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), action: .send(.confirmButtonTapped))
            )
            return .none
            
        case .failedToOpenAddress:
            state.alert = .init(
                title: TextState("Failed to open address in Maps"),
                message: TextState("Make sure you have the right address. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), action: .send(.confirmButtonTapped))
            )
            return .none
            
        case .failedToOpenEmailAddress:
            state.alert = .init(
                title: TextState("Failed to open email address"),
                message: TextState("Make sure you have the right email address. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), action: .send(.confirmButtonTapped))
            )
            return .none
            
        case .didNotHaveAuthorization:
            state.alert = .init(
                title: TextState("Authorization to add contact"),
                message: TextState("Tap It requires access to your contacts, so that it can add this phone number to your contacts. No information is sent to Tap It nor to third-party servers."),
                primaryButton: .default(
                    TextState("OK"),
                    action: .send(.openAppSettings)
                ),
                secondaryButton: .cancel(action: .send(.confirmButtonTapped))
            )
            return .none
            
        case .failedToOpenPhone:
            state.alert = .init(
                title: TextState("Failed to open phone number"),
                message: TextState("Make sure you have the right phone number. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(
                    TextState("OK"),
                    action: .send(.confirmButtonTapped)
                )
            )
            return .none
        }
    }
}
