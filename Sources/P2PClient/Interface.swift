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

public enum P2PEvent {
    case browser(BrowserClient.Event)
    case listener(ListenerClient.Event)
    case connection(ConnectionClient.Event)
}

public struct BrowserClient {
    public enum Event {
        case stateUpdated(NWBrowser.State)
        case browseResultsChanged(Set<NWBrowser.Result.Change>)
    }
    
    public var create: (_ id: AnyHashable, _ bonjourService: String) -> Effect<Event, Never>
    public var startBrowsing: (_ id: AnyHashable, _ queue: DispatchQueue) -> Effect<Never, Never>
    public var stopBrowsing: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        create: @escaping (AnyHashable, String) -> Effect<Event, Never>,
        startBrowsing: @escaping (AnyHashable, DispatchQueue) -> Effect<Never, Never>,
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
                        _ presharedKey: String,
                        _ identity: String,
                        _ myPeerID: String) -> Effect<Event, Never>
    public var startListening: (_ id: AnyHashable, _ queue: DispatchQueue) -> Effect<Never, Never>
    public var stopListening: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        create: @escaping (AnyHashable, String, String, String, String) -> Effect<Event, Never>,
        startListening: @escaping (AnyHashable, DispatchQueue) -> Effect<Never, Never>,
        stopListening: @escaping (AnyHashable) -> Effect<Never, Never>
    ) {
        self.create = create
        self.startListening = startListening
        self.stopListening = stopListening
    }
}

public struct ConnectionClient {
    public enum Event {
        public enum StateEvent {
            case stateUpdated(NWConnection.State)
        }
        
        public enum MessageEvent {
            case receivedMessage(type: UInt32, data: Data)
            case receivedMessageError
        }
        
        case connectionState(StateEvent)
        case message(MessageEvent)
    }
    
    public var create: (_ id: AnyHashable, _ connection: NWConnection) -> Effect<Event.StateEvent, Never>
    public var startConnection: (_ id: AnyHashable, _ queue: DispatchQueue) -> Effect<Event.MessageEvent, Never>
    public var stopConnection: (_ id: AnyHashable) -> Effect<Never, Never>
    public var sendMessage: (_ id: AnyHashable, _ type: MessageType, _ content: Data) -> Effect<Never, Never>
    
    public init(
        create: @escaping (AnyHashable, NWConnection) -> Effect<Event.StateEvent, Never>,
        startConnection: @escaping (AnyHashable, DispatchQueue) -> Effect<Event.MessageEvent, Never>,
        stopConnection: @escaping (AnyHashable) -> Effect<Never, Never>,
        sendMessage: @escaping (AnyHashable, MessageType, Data) -> Effect<Never, Never>
    ) {
        self.create = create
        self.startConnection = startConnection
        self.stopConnection = stopConnection
        self.sendMessage = sendMessage
    }
}
