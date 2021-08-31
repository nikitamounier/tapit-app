import Foundation
import MapKit
@_exported import PhoneNumberKit

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
    case address(Coordinate)
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
            let associatedValues0 = try subContainer.decode(Coordinate.self, forKey: .associatedValue0)
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

extension Social: Hashable, Identifiable, Equatable {
    public typealias Hash = Int
    
    public var id: Social.Hash {
        self.hashValue
    }
}
