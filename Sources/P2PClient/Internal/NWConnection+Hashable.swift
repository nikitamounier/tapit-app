import Network

extension NWConnection: Equatable {
    public static func == (lhs: NWConnection, rhs: NWConnection) -> Bool {
        return lhs.endpoint == rhs.endpoint
    }
}

extension NWConnection: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.endpoint)
    }
}
