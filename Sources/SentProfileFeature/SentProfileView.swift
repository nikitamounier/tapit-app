import ComposableArchitecture
import HapticClient
import OpenSocialClient
import OpenSocialFeature
import SharedModels

public struct SentProfileState: Equatable {
    public var profile: SentProfile
    public var openSocial: OpenSocialState
}

public enum SentProfileAction: Equatable {
    case openSocial(OpenSocialAction)
    case setName(to: String)
    case addToCategory(ProfilesCategory)
    case removeFromCategory(ProfilesCategory)
    case removeSentProfile
}

public struct SentProfileEnvironment {
    public var haptic: HapticClient
    public var openSocial: OpenSocialClient
    public var openAppSettings: () -> Void
    
    public init(
        haptic: HapticClient,
        openSocial: OpenSocialClient,
        openAppSettings: @escaping () -> Void
    ) {
        self.haptic = haptic
        self.openSocial = openSocial
        self.openAppSettings = openAppSettings
    }
}

public let sentProfileReducer = Reducer<SentProfileState, SentProfileAction, SentProfileEnvironment>.combine(
    openSocialReducer
        .pullback(
            state: \.openSocial,
            action: .openSocial,
            environment: {
                OpenSocialEnvironment(
                    openSocial: $0.openSocial,
                    haptic: $0.haptic,
                    openAppSettings: $0.openAppSettings
                )
            }
        ),
    
    Reducer { state, action, environment in
        switch action {
        case let .setName(name):
            state.profile.name = name
            return .none
            
        case .addToCategory:
            return .none
            
        case .removeFromCategory:
            return .none
            
        case .removeSentProfile:
            return .none
            
        case .openSocial:
            return .none
        }
    }
)

extension CasePath where Root == SentProfileAction, Value == OpenSocialAction {
    static let openSocial = Self(
        embed: SentProfileAction.openSocial,
        extract: {
            guard case let .openSocial(openSocialAction) = $0 else { return nil }
            return openSocialAction
        }
    )
}
