import CasePaths
import CombineHelpers
import ComposableArchitecture
import OpenSocialClient

public enum AlertAction: Equatable {
    case cancelButtonTapped
    case confirmButtonTapped(effect: Effect<SentProfileAction, Never>?)
    
    case failedToOpenURL
    case failedToOpenAddress
    case failedToOpenEmailAddress
    case didNotHaveAuthorization
    case failedToOpenPhone
    
    public static func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
        switch (lhs, rhs) {
        case (.cancelButtonTapped, .cancelButtonTapped):
            return true
        case let (.confirmButtonTapped(lhsEffect), .confirmButtonTapped(rhsEffect)):
            return lhsEffect.debugDescription == rhsEffect.debugDescription
        case (_, _):
            return false
        }
    }
}

public let openSocialReducer = Reducer<AlertState<AlertAction>?, SentProfileAction, SentProfileEnvironment> { alert, action, env in
    switch action {
    case let .alert(alertAction):
        switch alertAction {
        case .cancelButtonTapped:
            alert = nil
            return .none
            
        case let .confirmButtonTapped(effect: effect):
            alert = nil
            return effect ?? .none
            
        case .failedToOpenURL:
            alert = .init(
                title: TextState("Failed to open URL"),
                message: TextState("Make sure you have the right username. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), send: .confirmButtonTapped(effect: nil))
            )
            return .none
            
        case .failedToOpenAddress:
            alert = .init(
                title: TextState("Failed to open address in Maps"),
                message: TextState("Make sure you have the right address. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), send: .confirmButtonTapped(effect: nil))
            )
            return .none
            
        case .failedToOpenEmailAddress:
            alert = .init(
                title: TextState("Failed to open email address"),
                message: TextState("Make sure you have the right email address. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(TextState("OK"), send: .confirmButtonTapped(effect: nil))
            )
            return .none
            
        case .didNotHaveAuthorization:
            alert = .init(
                title: TextState("Authorization to add contact"),
                message: TextState("Tap It requires access to your contacts, so that it can add this phone number to your contacts. No information is sent to Tap It nor to third-party servers."),
                dismissButton: .default(
                    TextState("OK"),
                    send: .confirmButtonTapped(effect: nil)
                )
            )
            return .none
            
        case .failedToOpenPhone:
            alert = .init(
                title: TextState("Failed to open phone number"),
                message: TextState("Make sure you have the right phone number. If it still doesn't work, delete this profile and tap the other person again."),
                dismissButton: .default(
                    TextState("OK"),
                    send: .confirmButtonTapped(effect: .fireAndForget(env.openAppSettings))
                )
            )
            return .none
        }
        
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
            .map { result -> SentProfileAction? in
                switch result {
                case .success:
                    return nil
                    
                case let .failure(error):
                    switch error {
                    case let .components(componentsError):
                        switch componentsError {
                        case .failedConvertingComponentsToURL, .failedOpeningURL:
                            return .alert(.failedToOpenURL)
                        }
                        
                    case let .maps(mapsError):
                        switch mapsError {
                        case .failedOpeningMaps:
                            return .alert(.failedToOpenAddress)
                        }
                        
                    case let .email(emailError):
                        switch emailError {
                        case .failedConvertingEmailToURL:
                            return .alert(.failedToOpenEmailAddress)
                        }
                        
                    case let .phone(phoneError):
                        switch phoneError {
                        case .failedHavingContactsAuthorization:
                            return .alert(.didNotHaveAuthorization)
                            
                        case .failedConvertingPhoneToURL, .failedOpeningPhoneURL:
                            return .alert(.failedToOpenPhone)
                        }
                    }
                }
            }
            .compactMap(\.self)
            .fireAndForget()
        
    case .setName:
        return .none
        
    case .addToCategory:
        return .none
        
    case .removeFromCategory:
        return .none
        
    case .removeSentProfile:
        return .none
    }
}

extension CasePath where Root == SentProfileAction, Value == AlertAction {
    internal static let `self` = Self(
        embed: SentProfileAction.alert,
        extract: {
            guard case let .alert(action) = $0 else { return nil }
            return action
        }
    )
}
