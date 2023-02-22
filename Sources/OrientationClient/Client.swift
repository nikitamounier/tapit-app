import Dependencies

public struct OrientationClient: DependencyKey {
  public var horizontal: @Sendable () async -> Bool
  
  public init(horizontal: @escaping @Sendable () async -> Bool) {
    self.horizontal = horizontal
  }
}

public extension DependencyValues {
  var orientationClient: OrientationClient {
    get { self[OrientationClient.self] }
    set { self[OrientationClient.self] = newValue }
  }
}
