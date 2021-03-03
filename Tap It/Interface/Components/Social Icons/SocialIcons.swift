//
//  SocialIcons.swift
//  Tap It
//
//  Created by Nikita Mounier on 23/02/2021.
//

import SwiftUI

extension Image {
    enum SocialIcon: String, CaseIterable {
        case discord = "Discord"
        case facebook = "Facebook"
        case instagram = "Instagram"
        case linkedIn = "LinkedIn"
        case mail = "Mail"
        case phone = "Phone"
        case reddit = "Reddit"
        case snapchat = "Snapchat"
        case tikTok = "TikTok"
        case twitter = "Twitter"
        case weChat = "WeChat"
    }
    
    init(social: SocialIcon) {
        self.init(social.rawValue)
    }
}

