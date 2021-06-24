//
//  File.swift
//
//
//  Created by Nikita Mounier on 20/06/2021.
//

import Foundation

public struct UserProfile: Codable, Identifiable, Equatable {
    public let id: UUID
    
    public var name: String
    public var profileImage: ProfileImage

    public var socials: [Social]
    
    public init(id: UUID, name: String, profileImage: ProfileImage, socials: [Social]) {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.socials = socials
    }
}
