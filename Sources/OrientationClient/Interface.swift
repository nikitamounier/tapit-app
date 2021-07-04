import ComposableArchitecture

public struct OrientationClient {
    public enum OrientationEvent {
        case unknown
        case portrait
        case portraitUpsideDown
        case landscapeLeft
        case landscapeRight
        case faceUp
        case faceDown
    }
    
    public var start: () -> Effect<OrientationEvent, Never>
    public var stop: Effect<Never, Never>
    
    
    public init(
        start: @escaping () -> Effect<OrientationEvent, Never>,
        stop: Effect<Never, Never>
    ) {
        self.start = start
        self.stop = stop
    }
}
