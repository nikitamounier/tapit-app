import Foundation
import MapKit
import Overture
import PhoneNumberKit

extension Social {
    static let mockInstagram: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "instagram.com"
            $0.path = "/tapit_app/"
        }
        return .instagram(url)
    }()
    
    static let mockSnapchat: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "snapchat.com"
            $0.path = "/add/tapit_app"
        }
        return .snapchat(url)
    }()
    
    static let mockTwitter: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "twitter.com"
            $0.path = "/clattner_llvm"
        }
        return .twitter(url)
    }()
    
    static let mockFacebook: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "facebook.com"
            $0.path = "/tapit_app"
        }
        return .twitter(url)
    }()
    
    static let mockReddit: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "reddit.com"
            $0.path = "/user/tapit_app"
        }
        return .twitter(url)
    }()
    
    static let mockTikTok: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "tiktok.com"
            $0.path = "/@tapit_app"
        }
        return .twitter(url)
    }()
    
    // TODO: - Figure out WeChat ID
    static let mockWeChat: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "wechat.com"
            $0.path = "/tapit_app"
        }
        return .twitter(url)
    }()
    
    static let mockGithub: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "github.com"
            $0.path = "/lattner"
        }
        return .github(url)
    }()
    
    static let mockLinkedIn: Social = {
        let url = update(URLComponents()) {
            $0.scheme = "https"
            $0.host = "linkedin.com"
            $0.path = "/in/chris-lattner-5664498a"
        }
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

extension Array where Element == Social {
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

extension EmailAddress {
    static let mock = Self(rawValue: "support@tapit.com")!
}


extension CLLocationCoordinate2D {
    static let mock = Self(latitude: 37.3330, longitude: 122.0090)
}

extension ProfileImage {
    static let mock = Self(UIImage(systemName: "applelogo")!)
}

extension UserProfile {
    static let mock = Self(id: <#T##UUID#>, name: <#T##String#>, profileImage: <#T##ProfileImage#>, socials: <#T##[Social]#>)
}
