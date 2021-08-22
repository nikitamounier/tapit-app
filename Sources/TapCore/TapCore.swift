import BeaconClient
import Combine
import ComposableArchitecture
import CoreLocation
import FeedbackGeneratorClient
import GeneralMocks
import Network
import OrientationClient
import P2PClient
import ProximitySensorClient
import SharedModels
import SwiftUI

public struct TapState: Equatable {
    public var tapErrorAlert: AlertState<TapAction>?
    public var foundBeacons: [Beacon] = []
    public var browserResults: Set<NWBrowser.Result> = []
}

public enum TapAction: Equatable {
    case startBeacons
    case beaconLocationAuthorizationDeniedResponse
    case beaconBluetoothAuthorizationDeniedResponse
    case rangedBeaconsResponse([Beacon])
    
    case startP2P
    case browserResultsChangedResponse(Set<NWBrowser.Result.Change>)
    
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
    public var feedbackGenerator: FeedbackGeneratorClient
    public var proximitySensor: ProximitySensorClient
    public var orientation: OrientationClient
    public var major: () -> UInt16
    public var minor: () -> UInt16
    public var openAppSettings: () -> Void
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        beaconQueue: AnySchedulerOf<DispatchQueue>,
        p2pQueue: AnySchedulerOf<DispatchQueue>,
        beacon: BeaconClient,
        p2p: P2PClient,
        feedbackGenerator: FeedbackGeneratorClient,
        proximitySensor: ProximitySensorClient,
        orientation: OrientationClient,
        major: @escaping () -> UInt16,
        minor: @escaping () -> UInt16,
        openAppSettings: @escaping () -> Void
    ) {
        self.mainQueue = mainQueue
        self.beaconQueue = beaconQueue
        self.p2pQueue = p2pQueue
        self.beacon = beacon
        self.p2p = p2p
        self.feedbackGenerator = feedbackGenerator
        self.proximitySensor = proximitySensor
        self.orientation = orientation
        self.major = major
        self.minor = minor
        self.openAppSettings = openAppSettings
    }
}

public let tapReducer = Reducer<TapState, TapAction, TapEnvironment> { state, action, env in
    struct BeaconDetectorID: Hashable {}
    struct BeaconAdvertiserID: Hashable {}
    
    struct P2PListenerID: Hashable {}
    struct P2PBrowserID: Hashable {}
    struct P2PConnectionID: Hashable {}
    
    struct CancelBeaconSetupID: Hashable {}
    struct CancelP2PSetupID: Hashable {}
    
    switch action {
    // MARK: - Beacons Logic
    case .startBeacons:
        return .merge(
            env.beacon.detector.createBeaconDetector(BeaconDetectorID(), .deadbeef, Bundle.main.bundleIdentifier!)
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
                BeaconAdvertiserID(), .deadbeef, 123, 456, Bundle.main.bundleIdentifier!
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
            
                .none
        )
            
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
        return .cancel(ids: CancelBeaconSetupID(), CancelP2PSetupID())
    }
}

