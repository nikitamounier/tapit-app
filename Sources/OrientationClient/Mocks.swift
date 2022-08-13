import XCTestDynamicOverlay

public extension OrientationClient {
    static let noop = Self { false }
}

#if DEBUG
public extension OrientationClient {
    static let unimplemented = Self(horizontal: XCTUnimplemented("\(Self.self).horizontal", placeholder: false))
}
#endif