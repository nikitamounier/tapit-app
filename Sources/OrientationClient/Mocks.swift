import Dependencies

public extension OrientationClient {
  static let previewValue = Self { false }
  static let testValue = Self(horizontal: unimplemented("\(Self.self).horizontal", placeholder: false))
}

#if DEBUG
public extension OrientationClient {
  static let unimplemented = Self(horizontal: XCTUnimplemented("\(Self.self).horizontal", placeholder: false))
}
#endif
