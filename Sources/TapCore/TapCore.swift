import BeaconClient
import Combine
import ComposableArchitecture
import CoreLocation
import FeedbackGeneratorClient
import GeneralMocks
import Network
import OrientationClient
import P2PClient
import P2PEncodeDecode
import ProximitySensorClient
import SharedModels
import SwiftUI

public struct TapState: Equatable {
    public var tapErrorAlert: AlertState<TapAction>?
    public var foundBeacons: [Beacon]
    public var peerInfo: String?
    public var browserResults: Set<NWBrowser.Result>
    public var foundConnections: [NWConnection: ConnectionInfo]
    public var hasReceivedProfile: Bool
    public var hasSentProfile: Bool
    
    public init(
        tapErrorAlert: AlertState<TapAction>? = nil,
        foundBeacons: [Beacon] = [],
        peerInfo: String? = nil,
        browserResults: Set<NWBrowser.Result> = [],
        foundConnections: [NWConnection: ConnectionInfo] = [:],
        hasReceivedProfile: Bool = false,
        hasSentProfile: Bool = false
    ) {
        self.tapErrorAlert = tapErrorAlert
        self.foundBeacons = foundBeacons
        self.browserResults = browserResults
        self.foundConnections = foundConnections
        self.hasReceivedProfile = hasReceivedProfile
        self.hasSentProfile = hasSentProfile
    }
    
    public struct ConnectionInfo: Equatable {
        public let date: Date
        public var lastPing: Date
        public var peerInfo: String?
    }
}

public enum TapAction: Equatable {
    case startBeacons
    case beaconLocationAuthorizationDeniedResponse
    case beaconBluetoothAuthorizationDeniedResponse
    case rangedBeaconsResponse([Beacon])
    
    case startP2P
    case browserResultsChangedResponse(Set<NWBrowser.Result.Change>)
    case listenerNewConnectionResponse(NWConnection)
    
    case createConnection(NWConnection)
    case receivePingResponse(from: NWConnection)
    case receivePeerInfoResponse(String, from: NWConnection)
    case receiveProfileResponse(UserProfile, from: NWConnection)
    
    case tapButtonTapped
    
    case startReconnectionTimer
    case timerResponse
    case pingExistingConnections
    case killFailingConnections
    case attemptNewConnections
    
    case cancelConnection(NWConnection)
    case connectionFailed
    
    case setupFailed
    case tapErrorAlertDismissed
    case openAppSettings
    case prepareFeedbackGenerator
    case cancelAll
}

public struct TapEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var beaconQueue: AnySchedulerOf<DispatchQueue>
    public var p2pQueue: AnySchedulerOf<DispatchQueue>
    public var beacon: BeaconClient
    public var p2p: P2PClient
    public var p2pEncodeDecode: P2PEncodeDecode
    public var feedbackGenerator: FeedbackGeneratorClient
    public var proximitySensor: ProximitySensorClient
    public var orientation: OrientationClient
    public var now: () -> Date
    public var openAppSettings: () -> Void
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        beaconQueue: AnySchedulerOf<DispatchQueue>,
        p2pQueue: AnySchedulerOf<DispatchQueue>,
        beacon: BeaconClient,
        p2p: P2PClient,
        p2pEncodeDecode: P2PEncodeDecode,
        feedbackGenerator: FeedbackGeneratorClient,
        proximitySensor: ProximitySensorClient,
        orientation: OrientationClient,
        uuid: @escaping () -> UUID,
        now: @escaping () -> Date,
        openAppSettings: @escaping () -> Void
    ) {
        self.mainQueue = mainQueue
        self.beaconQueue = beaconQueue
        self.p2pQueue = p2pQueue
        self.beacon = beacon
        self.p2p = p2p
        self.p2pEncodeDecode = p2pEncodeDecode
        self.feedbackGenerator = feedbackGenerator
        self.proximitySensor = proximitySensor
        self.orientation = orientation
        self.now = now
        self.openAppSettings = openAppSettings
    }
}

public let tapReducer = Reducer<TapState, TapAction, TapEnvironment> { state, action, env in
    struct BeaconDetectorID: Hashable {}
    struct BeaconAdvertiserID: Hashable {}
    
    struct P2PListenerID: Hashable {}
    struct P2PBrowserID: Hashable {}
    
    struct CancelBeaconSetupID: Hashable {}
    struct CancelP2PSetupID: Hashable {}
    
    struct ReconnectionTimerID: Hashable {}
    
    switch action {
        // MARK: - Beacons Logic
    case .startBeacons:
        return .merge(
            env.beacon.detector.createBeaconDetector(BeaconDetectorID(), env.beacon.detector.uuid(), Bundle.main.bundleIdentifier!)
                .subscribe(on: env.beaconQueue)
                .flatMap { event -> Effect<TapAction, Never> in
                    switch event {
                    case .authorizationChanged(.authorizedAlways), .authorizationChanged(.authorizedWhenInUse):
                        return env.beacon.detector.startDetectingBeacons(BeaconDetectorID())
                            .fireAndForget()
                        
                    case .authorizationChanged(.restricted), .authorizationChanged(.denied):
                        return .merge(
                            Effect(value: .beaconLocationAuthorizationDeniedResponse),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                        
                    case .authorizationChanged(.notDetermined):
                        return .none
                        
                    case .authorizationChanged:
                        return .none
                        
                    case let .ranged(beacons: beacons):
                        return Effect(value: .rangedBeaconsResponse(beacons))
                        
                    case .failedRanging, .failed:
                        return .merge(
                            Effect(value: .setupFailed),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                    }
                }
                .receive(on: env.mainQueue)
                .eraseToEffect(),
            
            env.beacon.advertiser.createBeaconAdvertiser(
                BeaconAdvertiserID(),
                env.beacon.advertiser.uuid(),
                env.beacon.advertiser.major(),
                env.beacon.advertiser.minor(),
                Bundle.main.bundleIdentifier!
            )
                .subscribe(on: env.beaconQueue)
                .flatMap { event -> Effect<TapAction, Never> in
                    switch event {
                    case .stateUpdated(.poweredOn):
                        return env.beacon.advertiser.startAdvertisingBeacon(BeaconAdvertiserID())
                            .fireAndForget()
                        
                    case .stateUpdated(.poweredOff), .stateUpdated(.unsupported):
                        return .merge(
                            Effect(value: .setupFailed),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                        
                    case .stateUpdated(.unauthorized):
                        return .merge(
                            Effect(value: .beaconBluetoothAuthorizationDeniedResponse),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                        
                    case .stateUpdated(.resetting), .stateUpdated(.unknown):
                        return .none
                        
                    case .stateUpdated:
                        return .none
                        
                    case .didNotStartAdvertising:
                        return .merge(
                            Effect(value: .setupFailed),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                    }
                }
                .receive(on: env.mainQueue)
                .eraseToEffect()
        )
            .cancellable(id: CancelBeaconSetupID())
        
    case .beaconLocationAuthorizationDeniedResponse:
        state.tapErrorAlert = .init(
            title: TextState("Authorization to use general location"),
            message: TextState("Tap It requires access to your general location so that it can accurately send your selected information to the other person. Your location information isn't sent to Tap It nor to third-party servers."),
            primaryButton: .default(
                TextState("Open Settings"),
                action: .send(.openAppSettings)
            ),
            secondaryButton: .cancel(action: .send(.tapErrorAlertDismissed))
        )
        return .cancel(id: CancelBeaconSetupID())
        
    case .beaconBluetoothAuthorizationDeniedResponse:
        state.tapErrorAlert = .init(
            title: TextState("Authorization to use Bluetooth"),
            message: TextState("Tap It requires access to Bluetooth so that it can accurately send your selected information to the other person. Your Bluetooth information isn't sent to Tap It nor to third-party servers."),
            primaryButton: .default(
                TextState("Open Settings"),
                action: .send(.openAppSettings)
            ),
            secondaryButton: .cancel(action: .send(.tapErrorAlertDismissed))
        )
        return .cancel(id: CancelBeaconSetupID())
        
    case let .rangedBeaconsResponse(beacons):
        state.foundBeacons = beacons
        return .none
        
        // MARK: -  P2P logic
        
    case .startP2P:
        return .merge(
            env.p2p.browser.create(P2PBrowserID(), "_deadbeef._tcp")
                .subscribe(on: env.p2pQueue)
                .flatMap { event -> Effect<TapAction, Never> in
                    switch event {
                    case .stateUpdated(.ready):
                        return env.p2p.browser.startBrowsing(P2PBrowserID())
                            .fireAndForget()
                        
                    case .stateUpdated(.failed):
                        return Effect(value: .setupFailed)
                        
                    case .stateUpdated(.waiting), .stateUpdated(.cancelled):
                        return .none
                        
                    case .stateUpdated:
                        return .none
                        
                    case let .browseResultsChanged(changes):
                        return Effect(value: .browserResultsChangedResponse(changes))
                    }
                }
                .receive(on: env.mainQueue)
                .eraseToEffect(),
            
            env.p2p.listener.create(P2PListenerID(), "_deadbeef._tcp", env.p2p.listener.uuid().uuidString)
                .subscribe(on: env.p2pQueue)
                .flatMap { event -> Effect<TapAction, Never> in
                    switch event {
                    case .failedToCreate:
                        return .merge(
                            Effect(value: .setupFailed),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                        
                    case .stateUpdated(.ready):
                        return env.p2p.listener.startListening(P2PListenerID())
                            .fireAndForget()
                        
                    case .stateUpdated(.failed):
                        return .merge(
                            Effect(value: .setupFailed),
                            env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                        )
                        
                    case .stateUpdated(.setup), .stateUpdated(.waiting), .stateUpdated(.cancelled):
                        return .none
                        
                    case .stateUpdated:
                        return .none
                        
                    case let .foundNewConnection(connection):
                        return Effect(value: .listenerNewConnectionResponse(connection))
                    }
                }
                .receive(on: env.mainQueue)
                .eraseToEffect()
        )
            .cancellable(id: CancelP2PSetupID())
        
    case let .browserResultsChangedResponse(changes):
        changes.forEach { change in
            switch change {
            case let .added(result):
                state.browserResults.insert(result)
                
            case let .removed(result):
                state.browserResults.remove(result)
                
            case .identical, .changed:
                break
                
            @unknown default:
                break
            }
        }
        return .none
        
    case let .listenerNewConnectionResponse(connection):
        guard !state.foundConnections.keys.contains(connection) else {
            connection.cancel()
            return .none
        }
        
        return Effect(value: .createConnection(connection))
        
    case let .createConnection(connection):
        state.foundConnections[connection] = .init(date: env.now(), lastPing: env.now())
        
        return env.p2p.connection.create(connection.endpoint, connection)
            .subscribe(on: env.p2pQueue)
            .flatMap { [state] event -> Effect<TapAction, Never> in
                switch event {
                case .stateUpdated(.ready) where state.peerInfo != nil:
                    guard let data = env.p2pEncodeDecode.encodePeerInfo(state.peerInfo!)
                    else { return Effect(value: .setupFailed) }
                    
                    return env.p2p.connection.startConnection(connection.endpoint)
                        .flatMap { event -> Effect<TapAction, Never> in
                            switch event {
                            case .receivedMessage(type: MessageType.ping.rawValue, data: _): // received ping
                                return Effect(value: .receivePingResponse(from: connection))
                                
                            case let .receivedMessage(type: MessageType.peerInfo.rawValue, data: data): // received peer info
                                guard let peerInfo = env.p2pEncodeDecode.decodePeerInfo(data)
                                else { return Effect(value: .connectionFailed) }
                                
                                return Effect(value: .receivePeerInfoResponse(peerInfo, from: connection))
                                
                            case let .receivedMessage(type: MessageType.profile.rawValue, data: data): // received profile
                                guard let profile = env.p2pEncodeDecode.decodeUserProfile(data)
                                else { return Effect(value: .connectionFailed) }
                                
                                return Effect(value: .receiveProfileResponse(profile, from: connection))
                                
                            case .receivedMessage:
                                return .none
                                
                            case .receivedMessageError:
                                return Effect(value: .connectionFailed)
                                
                            case .stateUpdated:
                                return .none
                            }
                        }
                        .eraseToEffect()
                    
                case .stateUpdated(.ready) where state.peerInfo == nil:
                    return .none
                    
                case .stateUpdated(.failed):
                    return .merge(
                        Effect(value: .connectionFailed),
                        env.feedbackGenerator.notificationOccurred(.error).fireAndForget()
                    )
                    
                case .stateUpdated(.cancelled):
                    return Effect(value: .cancelConnection(connection))
                    
                case .stateUpdated(.waiting), .stateUpdated(.preparing), .stateUpdated(.setup):
                    return .none
                    
                case .stateUpdated:
                    return .none
                    
                case .receivedMessage:
                    return .none
                    
                case .receivedMessageError:
                    return .none
                }
            }
            .receive(on: env.mainQueue)
            .eraseToEffect()
        
    case let .cancelConnection(connection):
        return env.p2p.connection.stopConnection(connection.endpoint)
            .fireAndForget()
        
    case let .receivePingResponse(connection):
        state.foundConnections[connection]?.lastPing = env.now()
        return .none
        
    case let .receivePeerInfoResponse(peerInfo, from: connection):
        state.foundConnections[connection]?.peerInfo = peerInfo
        return .none
        
    case let .receiveProfileResponse(profile, from: connection):
        state.hasReceivedProfile = true
        return .merge(
            .cancel(id: CancelBeaconSetupID()),
            Effect(value: .cancelConnection(connection)),
            state.hasSentProfile ? .cancel(id: CancelP2PSetupID()) : env.p2p.browser.stopBrowsing(P2PBrowserID()).fireAndForget()
        )
        
    case .tapButtonTapped:
        return env.proximitySensor.start()
            .combineLatest(env.orientation.start())
            .filter { proximity, orientation in
                switch (proximity, orientation) {
                case .inProximity, .faceDown: return true
                case .inProximity, .faceUp: return true
                default: return false
                }
            }
            .flatMap { _ in /* send message if have peerID */ }
        
    case .startReconnectionTimer:
        return Effect.timer(id: ReconnectionTimerID(), every: 3, on: env.mainQueue)
            .flatMap { _ in Effect(value: .timerResponse) }
            .eraseToEffect()
        
    case .timerResponse:
        return .merge(
            Effect(value: .pingExistingConnections),
            Effect(value: .killFailingConnections),
            Effect(value: .attemptNewConnections)
        )
        
    case .pingExistingConnections:
        return .merge(
            state.foundConnections.keys.map { env.p2p.connection.sendMessage($0.endpoint, .ping, Data()).fireAndForget() }
        )
        
    case .killFailingConnections:
        return .merge(
            state.foundConnections.keys
                .filter {
                    $0.state == .preparing
                    && env.now().timeIntervalSince(state.foundConnections[$0]?.date ?? env.now()) > 10
                }
                .map { env.p2p.connection.stopConnection($0.endpoint).fireAndForget() }
        )
        
    case .attemptNewConnections:
        return .merge(
            state.browserResults.map { result in
                env.p2p.connection.connectionExists(result.endpoint)
                    .flatMap { existence -> Effect<TapAction, Never> in
                        guard !existence,
                              case let .service(name, type, _, _) = result.endpoint,
                              type == "_deadbeef._tcp" && name < env.p2p.listener.uuid().uuidString
                        else { return .none }
                        
                        let connection = NWConnection(
                            to: result.endpoint, using: NWParameters(enableKeepAlive: true, keepAliveIdle: 2, includePeerToPeer: true)
                        )
                        return Effect(value: .createConnection(connection))
                    }
                    .eraseToEffect()
            }
        )
        
    case .connectionFailed:
        state.tapErrorAlert = .init(
            title: TextState("Tap It encountered a connection error with the other person"),
            message: TextState("Make sure Wi-Fi is tuned on, and that Tap It has permission to your local network. No data is sent to Tap It nor to third-party servers."),
            dismissButton: .cancel(action: .send(.tapErrorAlertDismissed))
        )
        return Effect(value: .cancelAll)
        
        // MARK: - Shared Logic
        
    case .setupFailed:
        state.tapErrorAlert = .init(
            title: TextState("Tap It encountered an error while setting up your tap"),
            message: TextState("Make sure Wi-Fi and Bluetooth are turned on, and that Tap It has permission to use Bluetooth and access to your general location information. None of it is sent to Tap It nor to third-party servers."),
            dismissButton: .cancel(action: .send(.tapErrorAlertDismissed))
        )
        return Effect(value: .cancelAll)
        
    case .tapErrorAlertDismissed:
        state.tapErrorAlert = nil
        return .none
        
    case .openAppSettings:
        return .fireAndForget(env.openAppSettings)
        
    case .prepareFeedbackGenerator:
        return env.feedbackGenerator.prepareNotificationGenerator()
            .fireAndForget()
        
    case .cancelAll:
        return .cancel(ids: CancelBeaconSetupID(), CancelP2PSetupID(), ReconnectionTimerID())
    }
}

