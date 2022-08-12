public struct BeaconClient {
  var start: @Sendable (_ major: UInt16, _ minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error>
}

public struct Beacon: Equatable {
  let major: UInt16
  let minor: UInt16
  let proximity: Proximity
  let accuracy: Double
  let rssi: Int
  
  enum Proximity: Int {
    case unknown, immediate, near, far
  }
}

