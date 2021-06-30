import Foundation

@dynamicMemberLookup
public struct SentProfile: Codable, Identifiable, Equatable {
    public let profile: UserProfile
    
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
    public subscript<T>(dynamicMember keyPath: KeyPath<UserProfile, T>) -> T {
        profile[keyPath: keyPath]
    }
    
    public init(profile: UserProfile, sendDate: Date, expirationInterval: Days) {
        self.profile = profile
        self.sendDate = sendDate
        self.expirationInterval = expirationInterval
    }
}

public struct Days: Codable, Equatable {
    public let amount: Int
    
    public init(_ amount: Int) {
        self.amount = amount
    }
}
