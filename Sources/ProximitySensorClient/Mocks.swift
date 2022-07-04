import ComposableArchitecture

public extension ProximitySensorClient {
    static let noop = Self(
        start:  { .none },
        stop: .none
    )
    
    #if DEBUG
    static let unimplemented = Self(
        start: { .unimplemented("\(Self.self).start") },
        stop: .unimplemented("\(Self.self).stop")
    )
    #endif
}
