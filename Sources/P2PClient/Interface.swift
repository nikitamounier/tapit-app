import ComposableArchitecture
import Network

public struct P2PClient {
    public var browser: BrowserClient
    public var listener: ListenerClient
    public var connection: ConnectionClient
    
    public init(
        browser: BrowserClient,
        listener: ListenerClient,
        connection: ConnectionClient
    ) {
        self.browser = browser
        self.listener = listener
        self.connection = connection
    }
}

public struct BrowserClient {
    public enum Event {
        case stateUpdated(NWBrowser.State)
        case browseResultsChanged(Set<BrowserResult.Change>)
    }
    
    public var create: (_ id: AnyHashable, _ bonjourService: String) -> Effect<Event, Never>
    public var startBrowsing: (_ id: AnyHashable) -> Effect<Never, Never>
    public var stopBrowsing: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        create: @escaping (AnyHashable, String) -> Effect<Event, Never>,
        startBrowsing: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopBrowsing: @escaping (AnyHashable) -> Effect<Never, Never>
    ) {
        self.create = create
        self.startBrowsing = startBrowsing
        self.stopBrowsing = stopBrowsing
    }
}

public struct ListenerClient {
    public enum Event {
        case failedToCreate
        case stateUpdated(NWListener.State)
        case foundNewConnection(NWConnection)
    }
    
    public var create: (_ id: AnyHashable,
                        _ bonjourService: String,
                        _ myPeerID: String) -> Effect<Event, Never>
    public var startListening: (_ id: AnyHashable) -> Effect<Never, Never>
    public var stopListening: (_ id: AnyHashable) -> Effect<Never, Never>
    public var uuid: () -> UUID
    
    public init(
        create: @escaping (AnyHashable, String, String) -> Effect<Event, Never>,
        startListening: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopListening: @escaping (AnyHashable) -> Effect<Never, Never>,
        uuid: @escaping () -> UUID
    ) {
        self.create = create
        self.startListening = startListening
        self.stopListening = stopListening
        self.uuid = uuid
    }
}

public struct ConnectionClient {
    public enum Event {
        case stateUpdated(NWConnection.State)
        case receivedMessage(type: MessageType, data: Data)
        case receivedMessageError
    }
    
    public var create: (_ id: AnyHashable, _ connection: NWConnection) -> Effect<Event, Never>
    public var startConnection: (_ id: AnyHashable) -> Effect<Event, Never>
    public var stopConnection: (_ id: AnyHashable) -> Effect<Never, Never>
    public var sendMessage: (_ id: AnyHashable, _ type: MessageType, _ content: Data) -> Effect<Never, Never>
    public var connectionExists: (_ id: AnyHashable) -> Bool
    
    public init(
        create: @escaping (AnyHashable, NWConnection) -> Effect<Event, Never>,
        startConnection: @escaping (AnyHashable) -> Effect<Event, Never>,
        stopConnection: @escaping (AnyHashable) -> Effect<Never, Never>,
        sendMessage: @escaping (AnyHashable, MessageType, Data) -> Effect<Never, Never>,
        connectionExists: @escaping (_ id: AnyHashable) -> Bool
    ) {
        self.create = create
        self.startConnection = startConnection
        self.stopConnection = stopConnection
        self.sendMessage = sendMessage
        self.connectionExists = connectionExists
    }
}
