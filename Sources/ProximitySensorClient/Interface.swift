import ComposableArchitecture

public struct ProximitySensorClient {
    public enum ProximityEvent {
        case inProximity
    }
    
    public var start: () -> Effect<ProximityEvent, Never>
    public var stop: Effect<Never, Never>
    
    
    public init(
        start: @escaping () -> Effect<ProximitySensorClient.ProximityEvent, Never>,
        stop: Effect<Never, Never>
    ) {
        self.start = start
        self.stop = stop
    }
}
