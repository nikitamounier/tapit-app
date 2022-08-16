import Foundation

public struct BeaconClient {
  public var start: @Sendable (_ major: UInt16, _ minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error>

  public init(start: @escaping @Sendable (_ major: UInt16, _ minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error>) {
    self.start = start
  }
}

public struct Beacon: Equatable {
  public let major: UInt16
  public let minor: UInt16
  public let proximity: Proximity
  public let accuracy: Double
  public let rssi: Int
  
  public enum Proximity: Int {
    case unknown, immediate, near, far
  }
}
