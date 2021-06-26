import Foundation
import MapKit
import PhoneNumberKit

public enum Social {
    case instagram(URLComponents)
    case snapchat(URLComponents)
    case twitter(URLComponents)
    case facebook(URLComponents)
    case reddit(URLComponents)
    case tikTok(URLComponents)
    case weChat(URLComponents)
    case github(URLComponents)
    case linkedIn(URLComponents)
    case address(CLLocationCoordinate2D)
    case email(EmailAddress)
    case phone(PhoneNumber)
}

extension Social: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case associatedValues

        enum InstagramKeys: String, CodingKey {
            case associatedValue0
        }
        enum SnapchatKeys: String, CodingKey {
            case associatedValue0
        }
        enum TwitterKeys: String, CodingKey {
            case associatedValue0
        }
        enum FacebookKeys: String, CodingKey {
            case associatedValue0
        }
        enum RedditKeys: String, CodingKey {
            case associatedValue0
        }
        enum TikTokKeys: String, CodingKey {
            case associatedValue0
        }
        enum WeChatKeys: String, CodingKey {
            case associatedValue0
        }
        enum GithubKeys: String, CodingKey {
            case associatedValue0
        }
        enum LinkedInKeys: String, CodingKey {
            case associatedValue0
        }
        enum AddressKeys: String, CodingKey {
            case associatedValue0
        }
        enum EmailKeys: String, CodingKey {
            case associatedValue0
        }
        enum PhoneKeys: String, CodingKey {
            case associatedValue0
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "instagram":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.InstagramKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .instagram(associatedValues0)
        case "snapchat":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.SnapchatKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .snapchat(associatedValues0)
        case "twitter":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.TwitterKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .twitter(associatedValues0)
        case "facebook":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.FacebookKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .facebook(associatedValues0)
        case "reddit":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.RedditKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .reddit(associatedValues0)
        case "tikTok":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.TikTokKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .tikTok(associatedValues0)
        case "weChat":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.WeChatKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .weChat(associatedValues0)
        case "github":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.GithubKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .github(associatedValues0)
        case "linkedIn":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.LinkedInKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(URLComponents.self, forKey: .associatedValue0)
            self = .linkedIn(associatedValues0)
        case "address":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.AddressKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(CLLocationCoordinate2D.self, forKey: .associatedValue0)
            self = .address(associatedValues0)
        case "email":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.EmailKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(EmailAddress.self, forKey: .associatedValue0)
            self = .email(associatedValues0)
        case "phone":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.PhoneKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(PhoneNumber.self, forKey: .associatedValue0)
            self = .phone(associatedValues0)
        default:
            throw DecodingError.keyNotFound(CodingKeys.type, .init(codingPath: container.codingPath, debugDescription: "Unknown key"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .instagram(associatedValue0):
            try container.encode("instagram", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.InstagramKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .snapchat(associatedValue0):
            try container.encode("snapchat", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.SnapchatKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .twitter(associatedValue0):
            try container.encode("twitter", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.TwitterKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .facebook(associatedValue0):
            try container.encode("facebook", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.FacebookKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .reddit(associatedValue0):
            try container.encode("reddit", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.RedditKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .tikTok(associatedValue0):
            try container.encode("tikTok", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.TikTokKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .weChat(associatedValue0):
            try container.encode("weChat", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.WeChatKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .github(associatedValue0):
            try container.encode("github", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.GithubKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .linkedIn(associatedValue0):
            try container.encode("linkedIn", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.LinkedInKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .address(associatedValue0):
            try container.encode("address", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.AddressKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .email(associatedValue0):
            try container.encode("email", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.EmailKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        case let .phone(associatedValue0):
            try container.encode("phone", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.PhoneKeys.self, forKey: .associatedValues)
            try subContainer.encode(associatedValue0, forKey: .associatedValue0)
        }
    }
}


extension Social: Equatable {}

#if DEBUG

import Overture

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
    
    static let mockEmail: Social = .email(.init(rawValue: "tapit_app@gmail.com")!)
    
    static let mockPhone: Social = {
        let manager = PhoneNumberKit()
        let phoneNumber = try! manager.parse("+44 7700 900477")
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

#endif
