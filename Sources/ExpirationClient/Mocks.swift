import XCTestDynamicOverlay

public extension ExpirationClient {
    static let noop = Self(isExpired: { _, _ in false })
    
    #if DEBUG
    static let failing = Self(
        isExpired: { _, _ in
            XCTFail("\(Self.self).isExpired is unimplemented")
            return false
        }
    )
    #endif
}
