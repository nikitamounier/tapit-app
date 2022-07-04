import ComposableArchitecture

public extension OrientationClient {
    static var noop = Self(
        start: { .none },
        stop: .none
    )
    
    #if DEBUG
    static var unimplemented = Self(
        start: { .unimplemented("\(Self.self).start") },
        stop: .unimplemented("\(Self.self).stop")
    )
    #endif
}
