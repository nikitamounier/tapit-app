// Since NWBrowser.Result doesn't have a public initializer
import Network

public struct BrowserResult: Hashable, Equatable {
    public let endpoint: NWEndpoint
    public let interfaces: [NWInterface]
    public let metadata: NWBrowser.Result.Metadata

    public init(
        endpoint: NWEndpoint,
        interfaces: [NWInterface],
        metadata: NWBrowser.Result.Metadata) {
        self.endpoint = endpoint
        self.interfaces = interfaces
        self.metadata = metadata
    }
    
    public init(_ result: NWBrowser.Result) {
        self.endpoint = result.endpoint
        self.interfaces = result.interfaces
        self.metadata = result.metadata
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(endpoint)
        hasher.combine(interfaces)
    }
    
    public enum Change: Hashable {
        case identical
        case added(BrowserResult)
        case removed(BrowserResult)
        case changed(old: BrowserResult, new: BrowserResult, flags: NWBrowser.Result.Change.Flags)
        
        public init(_ change: NWBrowser.Result.Change) {
            switch change {
            case .identical:
                self = .identical
            case let .added(result):
                self = .added(.init(result))
            case let .removed(result):
                self = .removed(.init(result))
            case let .changed(old: oldResult, new: newResult, flags: flags):
                self = .changed(old: .init(oldResult), new: .init(newResult), flags: flags)
            @unknown default:
                fatalError()
            }
        }
    }
}

extension Set where Element == NWBrowser.Result.Change {
    func setMap<T: Hashable>(_ transform: (Element) -> T) -> Set<T> {
        var newSet: Set<T> = []
        newSet.reserveCapacity(self.count)
        for change in self {
            newSet.insert(transform(change))
        }
        return newSet
    }
}
