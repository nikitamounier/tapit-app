public extension BeaconClient {
  static let noop = Self { _, _ in .finished }
}

#if DEBUG
import XCTestDynamicOverlay

public extension BeaconClient {
  static let unimplemented = Self(start: XCTUnimplemented("\(Self.self).contains", placeholder: .finished))
}
#endif
