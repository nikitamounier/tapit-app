import XCTestDynamicOverlay

public extension ExpirationClient {
    static let noop = Self(isExpired: { _, _ in false })
    
    #if DEBUG
    static let unimplemented = Self(
        isExpired: XCTUnimplemented("\(Self.self).isExpired")
    )
    #endif
}
