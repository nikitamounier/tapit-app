import Foundation
import GeneralMocks
import MapKit
import Optics
import PhoneNumberKit
import Prelude

public extension EmailAddress {
    static let mock = Self(rawValue: "support@tapit.com")!
}


public extension Coordinate {
    static let mock = Self(latitude: 37.3330, longitude: 122.0090)
}

public extension Social {
    static func mockInstagram(name: String? = nil) -> Social {
        let url = URLComponents()
        |> \.scheme .~ "https"
        |> \.host .~ "instagram.com"
        |> \.path .~ "/\(name ?? "tapit_app")/"
        
        return .instagram(url)
    }
    
    static func mockSnapchat(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "snapchat.com"
            |> \.path .~ "/add/\(name ?? "tapit_app")"
        
        return .snapchat(url)
    }
    
    static func mockTwitter(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "twitter.com"
            |> \.path .~ "/\(name ?? "clattner_llvm")"
        
        return .twitter(url)
    }
    
    static func mockFacebook(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "facebook.com"
            |> \.path .~ "/\(name ?? "tapit_app")"
        
        return .twitter(url)
    }
    
    static func mockReddit(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "reddit.com"
            |> \.path .~ "/user/\(name ?? "tapit_app")"
        
        return .twitter(url)
    }
    
    static func mockTikTok(name: String? = nil) -> Social {
        let url = URLComponents()
        |> \.scheme .~ "https"
        |> \.host .~ "tiktok.com"
        |> \.path .~ "/@\(name ?? "tapit_app")"
        
        return .twitter(url)
    }
    
    // TODO: - Figure out WeChat ID
    static func mockWeChat(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "wechat.com"
            |> \.path .~ "/\(name ?? "tapit_app")"
        
        return .twitter(url)
    }
    
    static func mockGithub(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "github.com"
            |> \.path .~ "/\(name ?? "lattner")"
        
        return .github(url)
    }
    
    static func mockLinkedIn(name: String? = nil) -> Social {
        let url = URLComponents()
            |> \.scheme .~ "https"
            |> \.host .~ "linkedin.com"
            |> \.path .~ "/in/\(name ?? "chris-lattner-5664498a")"
        
        return .github(url)
    }
    
    static func mockAddress() -> Social { .address(.init(latitude: 37.3330, longitude: 122.0090)) }
    
    static func mockEmail(name: String? = nil) -> Social {
        let emailAddress = EmailAddress(rawValue: name ?? EmailAddress.mock.rawValue)
        
        return .email(emailAddress ?? .mock)
    }
    
    static func mockPhone() -> Social {
        let manager = PhoneNumberKit()
        let phoneNumber = try! manager.parse("+44 7565825633")
        return .phone(phoneNumber)
    }
}


public extension Array where Element == Social {
    static var mock: [Social] = [
        .mockInstagram(),
        .mockSnapchat(),
        .mockTwitter(),
        .mockFacebook(),
        .mockReddit(),
        .mockTikTok(),
        .mockWeChat(),
        .mockGithub(),
        .mockLinkedIn(),
        .mockAddress(),
        .mockEmail(),
        .mockPhone(),
    ]
    
}

public extension ProfileImage {
    static let mock = Self(UIImage(systemName: "applelogo")!)
}

public extension UserProfile {
    static let mock = Self(id: .deadbeef, name: "John Appleseed", profileImage: .mock, socials: .mock)
}

