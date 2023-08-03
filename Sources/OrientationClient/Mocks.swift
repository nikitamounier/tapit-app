import Dependencies

public extension OrientationClient {
  static let previewValue = Self { false }
  static let testValue = Self(horizontal: unimplemented("\(Self.self).horizontal", placeholder: false))
}
