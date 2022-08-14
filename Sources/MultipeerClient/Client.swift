import MultipeerKit
import SharedModels

public struct MultipeerClient {
  public var start: @Sendable (_ peerID: String) async -> AsyncStream<PeerID>
  public var send: @Sendable (UserProfile, _ to: PeerID) async throws -> ()
  public var receive: @Sendable (_ from: PeerID) async -> UserProfile
  
  public init(
    start: @escaping @Sendable (_ peerID: String) async -> AsyncStream<PeerID>,
    send: @escaping @Sendable (UserProfile, _ to: PeerID) async throws -> (),
    receive: @escaping @Sendable (_ from: PeerID) async -> UserProfile
  ) {
    self.start = start
    self.send = send
    self.receive = receive
    
  }
}

public struct PeerID: Equatable {
  public let name: String
  
  public init(name: String) {
    self.name = name
  }
}

