import Dependencies

public extension ProximitySensorClient {
  static let previewValue = Self { return false }
  static var testValue = Self(sensedProximity: unimplemented("\(Self.self)", placeholder: false))
}
