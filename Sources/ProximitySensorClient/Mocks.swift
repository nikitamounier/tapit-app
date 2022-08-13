import XCTestDynamicOverlay

public extension ProximitySensorClient {
  static let noop = Self { return false }
}

#if DEBUG
public extension ProximitySensorClient {
  static let unimplemented = Self(sensedProximity: XCTUnimplemented("\(Self.self)", placeholder: false))
}
#endif
