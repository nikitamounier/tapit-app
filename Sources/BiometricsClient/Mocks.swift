import Dependencies

public extension BiometricsClient {
  static let previewValue = Self { .passed }
  static let testValue = Self(authenticate: unimplemented("BiometricsClient.authenticate", placeholder: .cancelled))
}
