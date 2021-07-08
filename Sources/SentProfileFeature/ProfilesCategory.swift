@dynamicMemberLookup
public enum ProfilesCategory: Hashable, Equatable {
    case all
    case custom(name: String, profileIDs: Set<SentProfile.ID>)

    @inline(__always)
    public subscript<Value>(dynamicMember keyPath: KeyPath<Set<SentProfile.ID>, Value>) -> Value? {
        guard case .custom(name: _, profileIDs: let profileIDs) = self else { return nil }
        return profileIDs[keyPath: keyPath]
    }
    
    // Since in-place mutation of enum associated value doesn't exist yet
    @discardableResult
    public mutating func add(_ id: SentProfile.ID) -> Bool {
        guard case .custom(let name, var profileIDs) = self else { return false }
        withUnsafeMutablePointer(to: &self) { ptr in
            ptr.deinitialize(count: 1)
            profileIDs.insert(id)
            ptr.initialize(to: .custom(name: name, profileIDs: profileIDs))
        }
        return true
    }
    
    @discardableResult
    public mutating func addMany<IDs>(_ ids: IDs) -> Bool where IDs: Sequence, IDs.Element == SentProfile.ID {
        guard case .custom(let name, var profileIDs) = self else { return false }
        withUnsafeMutablePointer(to: &self) { ptr in
            ptr.deinitialize(count: 1)
            profileIDs.formUnion(ids)
            ptr.initialize(to: .custom(name: name, profileIDs: profileIDs))
        }
        return true
    }
    
    @discardableResult
    public mutating func remove(_ id: SentProfile.ID) -> Bool {
        guard case .custom(let name, var profileIDs) = self else { return false }
        withUnsafeMutablePointer(to: &self) { ptr in
            ptr.deinitialize(count: 1)
            profileIDs.remove(id)
            ptr.initialize(to: .custom(name: name, profileIDs: profileIDs))
        }
        return true
    }
    
    @discardableResult
    public mutating func removeMany<IDs>(_ ids: IDs) -> Bool where IDs: Sequence, IDs.Element == SentProfile.ID {
        guard case .custom(let name, var profileIDs) = self else { return false }
        withUnsafeMutablePointer(to: &self) { ptr in
            ptr.deinitialize(count: 1)
            profileIDs.formUnion(ids)
            ptr.initialize(to: .custom(name: name, profileIDs: profileIDs))
        }
        return true
    }
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
