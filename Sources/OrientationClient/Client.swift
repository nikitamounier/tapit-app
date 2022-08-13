public struct OrientationClient {
  public var horizontal: @Sendable () async -> Bool

  public init(horizontal: @escaping @Sendable () async -> Bool) {
    self.horizontal = horizontal
  }
}
