import BeaconClient
import Combine
import ComposableArchitecture
import FeedbackGeneratorClient
import OrientationClient
import P2PClient
import P2PEncodeDecode
import ProximitySensorClient
import SharedModels
import XCTest

@testable import TapCore
import Network

class TapCoreTests: XCTestCase {
    func testPerfectPath() {
        
        // MARK: - Setup
        
        let johnDoeProfile = UserProfile(
            id: .deadbeef,
            name: "John Doe",
            profileImage: .mock,
            socials: [
                .mockInstagram(name: "johndoe"),
                .mockTwitter(name: "johndoe"),
                .mockGithub(name: "johndoecodes"),
                .mockPhone()
            ]
        )
        
        let beaconDetectorEventPublisher = PassthroughSubject<DetectorClient.Event, Never>()
        let beaconAdvertiserEventPublisher = PassthroughSubject<AdvertiserClient.Event, Never>()
        
        let p2pBrowserEventPublisher = PassthroughSubject<BrowserClient.Event, Never>()
        let p2pListenerEventPublisher = PassthroughSubject<ListenerClient.Event, Never>()
        let p2pConnectionEventPublisher = PassthroughSubject<ConnectionClient.Event, Never>()
        
        let connectionExists = CurrentValueSubject<Bool, Never>(false)
        
        let proximityEventPublisher = PassthroughSubject<ProximitySensorClient.Event, Never>()
        
        let orientationEventPublisher = PassthroughSubject<OrientationClient.Event, Never>()
        
        let scheduler = DispatchQueue.test
        
        let store = TestStore(
            initialState: TapState(userProfile: johnDoeProfile),
            reducer: tapReducer,
            environment: TapEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                beaconQueue: .immediate,
                beacon: .failing,
                p2p: .failing,
                p2pEncodeDecode: .live,
                feedbackGenerator: .noop,
                proximitySensor: .failing,
                orientation: .failing,
                dispatchNow: { scheduler.now.dispatchTime },
                openAppSettings: {}
            )
        )
        
        store.environment.beacon = BeaconClient(
            detector: DetectorClient(
                createBeaconDetector: { _, _, _ in beaconDetectorEventPublisher.eraseToEffect() },
                startDetectingBeacons: { _ in .none },
                stopDetectingBeacons: { _ in .none },
                uuid: { .deadbeef }
            ),
            advertiser: AdvertiserClient(
                createBeaconAdvertiser: { _, _, _, _, _  in beaconAdvertiserEventPublisher.eraseToEffect() },
                startAdvertisingBeacon: { _ in .none },
                stopAdvertisingBeacon: { _ in .none },
                uuid: { .deadbeef },
                major: { 0 },
                minor: { 1 }
            )
        )
        
        store.environment.p2p = P2PClient(
            browser: BrowserClient(
                create: { _, _ in p2pBrowserEventPublisher.eraseToEffect() },
                startBrowsing: { _ in .none },
                stopBrowsing: { _ in .none }
            ),
            listener: ListenerClient(
                create: { _, _, _ in p2pListenerEventPublisher.eraseToEffect() },
                startListening: { _ in .none },
                stopListening: { _ in .none },
                uuid: { .deadbeef1 }
            ),
            connection: ConnectionClient(
                create: { _, _ in p2pConnectionEventPublisher.eraseToEffect() },
                startConnection: { _ in p2pConnectionEventPublisher.eraseToEffect() },
                stopConnection: { _ in .none },
                sendMessage: { _, _, _ in .none },
                connectionExists: { _ in connectionExists.eraseToEffect() })
        )
        
        store.environment.proximitySensor = ProximitySensorClient(
            start: { proximityEventPublisher.eraseToEffect() },
            stop: .none
        )
        
        store.environment.orientation = OrientationClient(
            start: { orientationEventPublisher.eraseToEffect() },
            stop: .none
        )
        
        // MARK: - Initialization
        
        store.send(.startReconnectionTimer)
        
        store.send(.startBeacons)
        
        beaconDetectorEventPublisher.send(.authorizationChanged(.authorizedAlways))
        scheduler.advance()
        
        beaconAdvertiserEventPublisher.send(.stateUpdated(.poweredOn))
        scheduler.advance()
        
        store.send(.startP2P)
        
        p2pListenerEventPublisher.send(.stateUpdated(.ready))
        scheduler.advance()
        
        p2pBrowserEventPublisher.send(.stateUpdated(.ready))
        scheduler.advance()
        
        
        // MARK: - Finding some beacon results
        
        scheduler.advance(by: 1)
        
        beaconDetectorEventPublisher.send(.ranged(
            beacons: [
                .init(uuid: .deadbeef, major: 120, minor: 430, proximity: .far, accuracy: 50, rssi: 20, timestamp: Date())
            ]
        ))
        
        store.receive(.rangedBeaconsResponse(
            [.init(uuid: .deadbeef, major: 120, minor: 430, proximity: .far, accuracy: 50, rssi: 20, timestamp: Date())]
        )) // shouldn't do anything since proxmity is .far
        scheduler.advance()
        
        scheduler.advance(by: 1)
        
        beaconDetectorEventPublisher.send(.ranged(
            beacons: [
                .init(uuid: .deadbeef, major: 120, minor: 430, proximity: .far, accuracy: 50, rssi: 20, timestamp: Date()),
                .init(uuid: .deadbeef1, major: 132, minor: 342, proximity: .near, accuracy: 30, rssi: 50, timestamp: Date()),
                .init(uuid: .deadbeef2, major: 145, minor: 256, proximity: .near, accuracy: 15, rssi: 60, timestamp: Date()),
            ]
        ))
        
        scheduler.advance()
        
        store.receive(.rangedBeaconsResponse([
            .init(uuid: .deadbeef, major: 120, minor: 430, proximity: .far, accuracy: 50, rssi: 20, timestamp: Date()),
            .init(uuid: .deadbeef1, major: 132, minor: 342, proximity: .near, accuracy: 30, rssi: 50, timestamp: Date()),
            .init(uuid: .deadbeef2, major: 145, minor: 256, proximity: .near, accuracy: 15, rssi: 60, timestamp: Date()),
        ])) {
            $0.peerInfo = "145-256" // takes last one since its accuracy value is lower (meaning it's closer)
        }
        
        scheduler.advance(by: 0.5)
        
        // MARK: - Finding some P2P results
        
        p2pBrowserEventPublisher.send(.browseResultsChanged([
            .added(BrowserResult(endpoint: .service(name: UUID.deadbeef.uuidString, type: "_deadbeef.tcp", domain: "", interface: nil), interfaces: [], metadata: .none))
        ]))
        scheduler.advance()
        
        store.receive(.browserResultsChangedResponse([
            .added(BrowserResult(endpoint: .service(name: UUID.deadbeef.uuidString, type: "_deadbeef.tcp", domain: "", interface: nil), interfaces: [], metadata: .none))
        ])) {
            $0.browserResults.insert(BrowserResult(endpoint: .service(name: UUID.deadbeef.uuidString, type: "_deadbeef.tcp", domain: "", interface: nil), interfaces: [], metadata: .none))
        }
        
        store.receive(.attemptNewConnections)
    }
}
