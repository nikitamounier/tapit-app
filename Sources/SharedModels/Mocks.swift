import Foundation
import GeneralMocks
import MapKit
import Optics
import PhoneNumberKit
import Prelude

public extension EmailAddress {
    static let mock = Self(rawValue: "support@tapit.com")!
}


public extension CLLocationCoordinate2D {
    static let mock = Self(latitude: 37.3330, longitude: 122.0090)
}

public extension Social {
    static let mockInstagram: Social = {
        let url = URLComponents()
        |> \.scheme .~ "https"
        |> \.host .~ "instagram.com"
        |> \.path .~ "/tapit_app/"
        
        return .instagram(url)
    }()
    
    static let mockSnapchat: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "snapchat.com"
            |> \.path .~ "/add/tapit_app"
        
        return .snapchat(url)
    }()
    
    static let mockTwitter: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "twitter.com"
            |> \.path .~ "/clattner_llvm"
        
        return .twitter(url)
    }()
    
    static let mockFacebook: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "facebook.com"
            |> \.path .~ "/tapit_app"
        
        return .twitter(url)
    }()
    
    static let mockReddit: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "reddit.com"
            |> \.path .~ "/user/tapit_app"
        
        return .twitter(url)
    }()
    
    static let mockTikTok: Social = {
        let url = URLComponents()
        |> \.scheme .~ "https"
        |> \.host .~ "tiktok.com"
        |> \.path .~ "/@tapit_app"
        
        return .twitter(url)
    }()
    
    // TODO: - Figure out WeChat ID
    static let mockWeChat: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "wechat.com"
            |> \.path .~ "/tapit_app"
        
        return .twitter(url)
    }()
    
    static let mockGithub: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "github.com"
            |> \.path .~ "/lattner"
        
        return .github(url)
    }()
    
    static let mockLinkedIn: Social = {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "linkedin.com"
            |> \.path .~ "/in/chris-lattner-5664498a"
        
        return .github(url)
    }()
    
    static let mockAddress: Social = .address(.init(latitude: 37.3330, longitude: 122.0090))
    
    static let mockEmail: Social = .email(.mock)
    
    static let mockPhone: Social = {
        let manager = PhoneNumberKit()
        let phoneNumber = try! manager.parse("+44 7565825633")
        return .phone(phoneNumber)
    }()
}

public extension Array where Element == Social {
    static let mock: [Social] = [
        .mockInstagram,
        .mockSnapchat,
        .mockTwitter,
        .mockFacebook,
        .mockReddit,
        .mockTikTok,
        .mockWeChat,
        .mockGithub,
        .mockLinkedIn,
        .mockAddress,
        .mockEmail,
        .mockPhone,
    ]
    
}

public extension ProfileImage {
    static let mock = Self(UIImage(systemName: "applelogo")!)
}

public extension UserProfile {
    static let mock = Self(id: .deadbeef, name: "John Appleseed", profileImage: .mock, socials: .mock)
}

