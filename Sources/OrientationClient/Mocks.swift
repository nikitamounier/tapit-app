import ComposableArchitecture

public extension OrientationClient {
    static var noop = Self(
        start: { .none },
        stop: .none
    )
    
    #if DEBUG
    static var failing = Self(
        start: { .failing("\(Self.self).start is unimplemented") },
        stop: .failing("\(Self.self).stop is unimplemented")
    )
    #endif
}
