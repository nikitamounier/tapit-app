import MultipeerKit
import SharedModels
import ComposableArchitecture


public extension MultipeerClient {
  static var liveValue: Self {
    let multipeer = Multipeer()
    
    return Self(
      start: { await multipeer.start(peerID: $0) } ,
      sendProfile: { try await multipeer.sendProfile($0, to: $1) },
      receiveProfile: { try await multipeer.receiveProfile(from: $0) },
      sendAck: { try await multipeer.sendAck(to: $0) },
      receiveAck: { try await multipeer.receiveAck(from: $0) }
    )
  }
}

public struct Ack: Codable {
  var padding: UInt8 = 0
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
  
  func sendProfile(_ profile: UserProfile, to peerID: PeerID) throws {
    guard let peer = transceiver?.availablePeers.first(where: { $0.name == peerID.name })
    else { throw Error.peerUnavailable }
    
    transceiver?.send(profile, to: [peer])
    print("sent profile")
  }
  
  func receiveProfile(from peerID: PeerID) async throws -> UserProfile {
    try Task.checkCancellation()
    return try await withCheckedThrowingContinuation { continuation in
        transceiver?.receive(UserProfile.self) { payload, senderPeer in
          guard senderPeer.name == peerID.name
          else {
            print("received profile – not same name")
            continuation.resume(throwing: Error.peerUnavailable)
            return
          }
          
          print("received profile")
          continuation.resume(returning: payload)
        }
    }
  }
  
  func sendAck(to peerID: PeerID) throws {
    guard let peer = transceiver?.availablePeers.first(where: { $0.name == peerID.name })
    else { throw Error.peerUnavailable }
    
    transceiver?.send(Ack(), to: [peer])
    print("sent ack")
  }
  
  func receiveAck(from peerID: PeerID) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      transceiver?.receive(Ack.self) { ack, senderPeer in
        guard senderPeer.name == peerID.name
        else {
          print("received ack from wrong peer")
          continuation.resume(throwing: Error.peerUnavailable)
          return
        }
        
        print("receive ack")
        continuation.resume()
      }
    }
  }
}
