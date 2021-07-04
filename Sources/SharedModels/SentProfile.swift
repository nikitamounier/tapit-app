import Foundation

@dynamicMemberLookup
public struct SentProfile: Codable, Identifiable, Hashable, Equatable {
    public var profile: UserProfile
    
    public let sendDate: Date
    public let expirationInterval: Days
    
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
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct Days: Codable, Equatable {
    public let amount: Int
    
    public init(_ amount: Int) {
        self.amount = amount
    }
}
