import Dependencies

public struct BiometricsClient: DependencyKey {
  public enum AuthenticationResult {
    case passed
    case failed
    case cancelled
  }
  
  public var authenticate: () async -> AuthenticationResult
  
  public init(authenticate: @escaping () async -> AuthenticationResult) {
    self.authenticate = authenticate
  }
}

public extension DependencyValues {
  var biometricsClient: BiometricsClient {
    get { self[BiometricsClient.self] }
    set { self[BiometricsClient.self] = newValue }
  }
}
