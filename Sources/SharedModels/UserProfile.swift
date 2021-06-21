//
//  File.swift
//  
//
//  Created by Nikita Mounier on 20/06/2021.
//

import UIKit

public struct UserProfile: Codable, Identifiable {
    public let id: UUID
    
    public var name: String
    public var profileImage: ProfileImage

    public var socials: [Social]
}
