import ComposableArchitecture
import SharedModels

@dynamicMemberLookup
public struct SentProfile: Codable, Identifiable, Equatable {
    public var profile: UserProfile
    
    public let sendDate: Date
    public let expirationInterval: Days
    
    public var openSocialFailed: AlertState<AlertAction>?
    
    public var isExpired: Bool {
        (Calendar.current.dateComponents([.day], from: sendDate, to: Date()).day ?? 0) > expirationInterval.amount ?
            true :
            false
    }
    
    public var id: UUID {
        profile.id
    }
    
    @inline(__always)
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<UserProfile, T>) -> T {
        get {
            profile[keyPath: keyPath]
        }
        set {
            profile[keyPath: keyPath] = newValue
        }
    }
    
    public init(profile: UserProfile, sendDate: Date, expirationInterval: Days) {
        self.profile = profile
        self.sendDate = sendDate
        self.expirationInterval = expirationInterval
    }
}

extension SentProfile {
    enum CodingKeys: CodingKey {
        case profile
        case sendDate
        case expirationInterval
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profile = try container.decode(UserProfile.self, forKey: .profile)
        self.sendDate = try container.decode(Date.self, forKey: .sendDate)
        self.expirationInterval = try container.decode(Days.self, forKey: .expirationInterval)
    }
}
