public struct HistoryCategory: Codable, Equatable {
    public var name: String
    public var profileIDs: Set<SentProfile.ID>
}

