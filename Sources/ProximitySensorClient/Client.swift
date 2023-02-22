import Dependencies

public struct ProximitySensorClient: DependencyKey {
  public var sensedProximity: @Sendable () async -> Bool
  
  public init(sensedProximity: @escaping @Sendable () async -> Bool) {
    self.sensedProximity = sensedProximity
  }
}

public extension DependencyValues {
  var proximitySensorClient: ProximitySensorClient {
    get { self[ProximitySensorClient.self] }
    set { self[ProximitySensorClient.self] = newValue }
  }
}
