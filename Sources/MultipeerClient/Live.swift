import MultipeerKit
import SharedModels
import ComposableArchitecture


public extension MultipeerClient {
  static var live: Self {
    let multipeer = Multipeer()
    
    return Self(
      start: { await multipeer.start(peerID: $0) } ,
      send: { try await multipeer.send(profile: $0, to: $1) },
      receive: { try await multipeer.receive(from: $0) }
    )
  }
}

private actor Multipeer {
  var transceiver: MultipeerTransceiver?
  
  enum Error: Swift.Error, Equatable {
    case peerUnavailable
  }
  
  func start(peerID: String) -> AsyncStream<PeerID> {
    
    var configuration: MultipeerConfiguration = .default
    configuration.peerName = peerID
    configuration.serviceType = "tapit"
    // TODO: - Change encryption to .required once have Apple Developer Program Membership
    configuration.security.encryptionPreference = .none
    
    guard !Task.isCancelled else { return .finished }
    
    transceiver = MultipeerTransceiver(configuration: configuration)
    transceiver?.resume()
    
    return AsyncStream { continuation in
      transceiver?.peerAdded = { newPeer in
        continuation.yield(PeerID(name: newPeer.name))
      }
      
      continuation.onTermination = { @Sendable [transceiver = UncheckedSendable(transceiver)] _ in
        transceiver.wrappedValue?.stop()
      }
    }
  }
  
  func send(profile: UserProfile, to peerID: PeerID) throws {
    guard let peer = transceiver!.availablePeers.first(where: { $0.name == peerID.name })
    else { throw Error.peerUnavailable }
    
    transceiver?.send(profile, to: [peer])
  }
  
  func receive(from peerID: PeerID) async throws -> UserProfile {
    try Task.checkCancellation()
    return try await withCheckedThrowingContinuation { continuation in
        transceiver?.receive(UserProfile.self) { payload, senderPeer in
          guard senderPeer.name == peerID.name
          else {
            continuation.resume(throwing: Error.peerUnavailable)
            return
          }
          
          continuation.resume(returning: payload)
        }
    }
  }
}
