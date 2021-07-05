import Combine

public extension Publisher {
    func compactMap(_ transform: KeyPath<Output, Output>) -> Publishers.CompactMap<Self, Output> {
        return self.compactMap { $0 }
    }
}
