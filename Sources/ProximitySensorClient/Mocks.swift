import ComposableArchitecture

public extension ProximitySensorClient {
    static let noop = Self(
        start:  { .none },
        stop: .none
    )
    
    #if DEBUG
    static let failing = Self(
        start: { .failing("\(Self.self).start is unimplemented") },
        stop: .failing("\(Self.self).stop is unimplemented")
    )
    #endif
}
