import Dependencies
import MultipeerKit
import SharedModels

public struct MultipeerClient: DependencyKey {
  public var start: @Sendable (_ peerID: String) async -> AsyncStream<PeerID>
  public var sendProfile: @Sendable (UserProfile, _ to: PeerID) async throws -> Void
  public var receiveProfile: @Sendable (_ from: PeerID) async throws -> UserProfile
  public var sendAck: @Sendable (_ to: PeerID) async throws -> Void
  public var receiveAck: @Sendable (_ from: PeerID) async throws -> Void
  
  public init(
    start: @escaping @Sendable (_ peerID: String) async -> AsyncStream<PeerID>,
    sendProfile: @escaping @Sendable (UserProfile, _ to: PeerID) async throws -> Void,
    receiveProfile:@escaping @Sendable (_ from: PeerID) async throws -> UserProfile,
    sendAck: @escaping @Sendable (_ to: PeerID) async throws -> Void,
    receiveAck: @escaping @Sendable (_ from: PeerID) async throws -> Void
  ) {
    self.start = start
    self.sendProfile = sendProfile
    self.receiveProfile = receiveProfile
    self.sendAck = sendAck
    self.receiveAck = receiveAck
    
  }
}

public struct PeerID: Equatable {
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
}

public enum CancelMultipeerID {}

public extension DependencyValues {
  var multipeerClient: MultipeerClient {
    get { self[MultipeerClient.self] }
    set { self[MultipeerClient.self] = newValue }
  }
}
