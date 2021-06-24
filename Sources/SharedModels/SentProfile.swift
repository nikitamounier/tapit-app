//
//  File.swift
//
//
//  Created by Nikita Mounier on 20/06/2021.
//

import Foundation

@dynamicMemberLookup
public struct SentProfile: Codable, Identifiable {
    public let profile: UserProfile
    
    public let sendDate: Date
    public let expirationInterval: Days
    
    public var isExpired: Bool {
        (Calendar.current.dateComponents([.day], from: sendDate, to: Date()).day ?? 0) > expirationInterval.amount ?
            true :
            false
    }
    
    @inline(__always)
    public subscript<T>(dynamicMember keyPath: KeyPath<UserProfile, T>) -> T {
        profile[keyPath: keyPath]
    }
    
    public var id: UUID {
        profile.id
    }
    
    public init(profile: UserProfile, sendDate: Date, expirationInterval: Days) {
        self.profile = profile
        self.sendDate = sendDate
        self.expirationInterval = expirationInterval
    }
}

public struct Days: Codable {
    public let amount: Int
    
    public init(amount: Int) {
        self.amount = amount
    }
}
