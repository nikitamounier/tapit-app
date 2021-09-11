import ComposableArchitecture

public struct ProximitySensorClient {
    public enum Event {
        case inProximity
        case notInProximity
    }
    
    public var start: () -> Effect<Event, Never>
    public var stop: Effect<Never, Never>
    
    
    public init(
        start: @escaping () -> Effect<Event, Never>,
        stop: Effect<Never, Never>
    ) {
        self.start = start
        self.stop = stop
    }
}
