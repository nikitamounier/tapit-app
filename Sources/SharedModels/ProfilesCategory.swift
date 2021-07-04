public enum ProfilesCategory: Hashable, Equatable {
    case all
    case custom(name: String, profileIDs: Set<SentProfile.ID>)
}

extension ProfilesCategory: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case associatedValues

        enum CustomKeys: String, CodingKey {
            case name
            case profileIDs
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .type) {
        case "all":
            self = .all
        case "custom":
            let subContainer = try container.nestedContainer(keyedBy: CodingKeys.CustomKeys.self, forKey: .associatedValues)
            let associatedValues0 = try subContainer.decode(String.self, forKey: .name)
            let associatedValues1 = try subContainer.decode(Set<SentProfile.ID>.self, forKey: .profileIDs)
            self = .custom(name: associatedValues0, profileIDs: associatedValues1)
        default:
            throw DecodingError.keyNotFound(CodingKeys.type, .init(codingPath: container.codingPath, debugDescription: "Unknown key"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .all:
            try container.encode("all", forKey: .type)
        case let .custom(name, profileIDs):
            try container.encode("custom", forKey: .type)
            var subContainer = container.nestedContainer(keyedBy: CodingKeys.CustomKeys.self, forKey: .associatedValues)
            try subContainer.encode(name, forKey: .name)
            try subContainer.encode(profileIDs, forKey: .profileIDs)
        }
    }
}

