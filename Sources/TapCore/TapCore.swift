import BeaconClient
import Combine
import ComposableArchitecture
import CoreLocation
import FeedbackGeneratorClient
import GeneralMocks
import OrientationClient
import P2PClient
import ProximitySensorClient
import SharedModels
import SwiftUI

public struct TapState: Equatable {
    public var tapErrorAlert: AlertState<TapAction>?
    public var foundBeacons: Set<Beacon> = []
}

public enum TapAction: Equatable {
    case startBeacons
    case beaconLocationAuthorizationDeniedResponse
    case beaconBluetoothAuthorizationDeniedResponse
    case rangedBeaconsResponse([Beacon])
    
    case setupFailed
    case tapErrorAlertDismissed
    case openAppSettings
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
                        return Effect(value: .beaconLocationAuthorizationDeniedResponse)
                        
                    case .authorizationChanged(.notDetermined):
                        return .none
                        
                    case .authorizationChanged:
                        return .none
                        
                    case let .ranged(beacons: beacons):
                        return Effect(value: .rangedBeaconsResponse(beacons))
                        
                    case .failedRanging, .failed:
                        return Effect(value: .setupFailed)
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
                        return Effect(value: .setupFailed)
                    
                    case .stateUpdated(.unauthorized):
                        return Effect(value: .beaconBluetoothAuthorizationDeniedResponse)
                    
                    case .stateUpdated(.resetting), .stateUpdated(.unknown):
                        return .none
                    
                    case .stateUpdated:
                        return .none
                    
                    case .didNotStartAdvertising:
                        return Effect(value: .setupFailed)
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
        state.foundBeacons.formUnion(beacons)
        return .none
        
    // MARK: -  P2P logic
        
        
        
        
        
        
        
        
        
        
        
        
    // MARK: - Shared Logic
        
    case .setupFailed:
        state.tapErrorAlert = .init(
            title: TextState("Tap It encountered an error while setting up your tap"),
            message: TextState("Make sure Wi-Fi and Bluetooth are turned on, and that Tap It has permission to use Bluetooth and access to your general location information. None of it is sent to Tap It nor to third-party servers."),
            dismissButton: .cancel(action: .send(.tapErrorAlertDismissed))
        )
        return .merge(
            .cancel(ids: CancelBeaconSetupID(), CancelP2PSetupID())
        )
        .fireAndForget()
        
    case .tapErrorAlertDismissed:
        state.tapErrorAlert = nil
        return .none
        
    case .openAppSettings:
        return .fireAndForget(env.openAppSettings)
    }
}

