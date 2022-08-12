import MultipeerKit
import SharedModels
import ComposableArchitecture


extension MultipeerClient {
    static var live: Self {
        let multipeer = Multipeer()
        
        return Self(
            start: { await multipeer.start(peerID: $0) } ,
            send: { try await multipeer.send(profile: $0, to: $1) },
            receive: { await multipeer.receive(from: $0) }
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
        configuration.security.encryptionPreference = .required
        
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
    
    func receive(from peerID: PeerID) async -> UserProfile {
        await withCheckedContinuation { continuation in
            transceiver?.receive(UserProfile.self) { payload, senderPeer in
                guard senderPeer.name == peerID.name
                else {
                  print("Received profile from wrong peer")
                  return
                }
                
                continuation.resume(returning: payload)
            }
        }
    }
}
