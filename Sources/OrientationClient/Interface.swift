import ComposableArchitecture

public struct OrientationClient {
    public enum Event {
        case unknown
        case portrait
        case portraitUpsideDown
        case landscapeLeft
        case landscapeRight
        case faceUp
        case faceDown
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
