import ComposableArchitecture
import CoreBluetooth
import CoreLocation

public struct BeaconClient {
    public var detector: DetectorClient
    public var advertiser: AdvertiserClient
    
    public init(detector: DetectorClient, advertiser: AdvertiserClient) {
        self.detector = detector
        self.advertiser = advertiser
    }
}

public enum BeaconAction {
    case detector(DetectorClient.Action)
    case advertiser(AdvertiserClient.Action)
}

public struct DetectorClient {
    public enum Action {
        case authorizationChanged(CLAuthorizationStatus)
        case failed(Error)
        case ranged(beacons: [CLBeacon])
        case failedRanging(Error)
    }
    
    public var createBeaconDetector: (_ id: AnyHashable,
                                      _ beaconsUUID: UUID,
                                      _ identifier: String) -> Effect<Action, Never>
    
    public var startDetectingBeacons: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public var stopDetectingBeacons: (_ id: AnyHashable) -> Effect<Never, Never>
    
    
    public init(
        createBeaconDetector: @escaping (AnyHashable, UUID, String) -> Effect<Action, Never>,
        startDetectingBeacons: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopDetectingBeacons: @escaping (AnyHashable) -> Effect<Never, Never>
    ) {
        self.createBeaconDetector = createBeaconDetector
        self.startDetectingBeacons = startDetectingBeacons
        self.stopDetectingBeacons = stopDetectingBeacons
    }
}

public struct AdvertiserClient {
    public enum Action {
        case stateUpdated(CBManagerState)
        case didNotStartAdvertising(Error)
    }
    
    public var createBeaconAdvertiser: (_ id: AnyHashable,
                                        _ beaconsUUID: UUID,
                                        _ major: UInt16,
                                        _ minor: UInt16,
                                        _ identifier: String) -> Effect<Action, Never>
    
    public var startAdvertisingBeacon: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public var stopAdvertisingBeacon: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        createBeaconAdvertiser: @escaping (AnyHashable, UUID, UInt16, UInt16, String) -> Effect<Action, Never>,
        startAdvertisingBeacon: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopAdvertisingBeacon: @escaping (AnyHashable) -> Effect<Never, Never>
    ) {
        self.createBeaconAdvertiser = createBeaconAdvertiser
        self.startAdvertisingBeacon = startAdvertisingBeacon
        self.stopAdvertisingBeacon = stopAdvertisingBeacon
    }
}
