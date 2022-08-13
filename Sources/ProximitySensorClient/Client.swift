public struct ProximitySensorClient {
  public var sensedProximity: @Sendable () async -> Bool
  
  public init(sensedProximity: @escaping @Sendable () async -> Bool) {
    self.sensedProximity = sensedProximity
  }
}
