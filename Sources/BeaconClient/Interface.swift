import ComposableArchitecture
import CoreBluetooth
import CoreLocation
import Foundation

public struct BeaconClient {
    public enum BeaconAction {
        case detector(DetectorAction)
        case advertiser(AdvertiserAction)
        
        public enum DetectorAction {
            case didChangeAuthorization(CLAuthorizationStatus)
            case didFail(Error)
            case didRange(beacons: [CLBeacon])
            case didFailRanging(Error)
        }
        
        public enum AdvertiserAction {
            case didUpdateState(CBManagerState)
            case didNotStartAdvertising(Error)
        }
        
    }
    
    public var createBeaconDetector: (_ id: AnyHashable,
                                      _ beaconsUUID: UUID,
                                      _ identifier: String) -> Effect<BeaconAction.DetectorAction, Never>
    
    public var startDetectingBeacons: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public var stopDetectingBeacons: (_ id: AnyHashable) -> Effect<Never, Never>
    
    
    public var createBeaconAdvertiser: (_ id: AnyHashable,
                                        _ beaconsUUID: UUID,
                                        _ major: UInt16,
                                        _ minor: UInt16,
                                        _ identifier: String) -> Effect<BeaconAction.AdvertiserAction, Never>
    
    public var startAdvertisingBeacon: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public var stopAdvertisingBeacon: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        createBeaconDetector: @escaping (AnyHashable, UUID, String) -> Effect<BeaconAction.DetectorAction, Never>,
        startDetectingBeacons: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopDetectingBeacons: @escaping (AnyHashable) -> Effect<Never, Never>,
        createBeaconAdvertiser: @escaping (AnyHashable, UUID, UInt16, UInt16, String) -> Effect<BeaconAction.AdvertiserAction, Never>,
        startAdvertisingBeacon: @escaping (AnyHashable) -> Effect<Never, Never>,
        stopAdvertisingBeacon: @escaping (AnyHashable) -> Effect<Never, Never>
    ) {
        self.createBeaconDetector = createBeaconDetector
        self.startDetectingBeacons = startDetectingBeacons
        self.stopDetectingBeacons = stopDetectingBeacons
        self.createBeaconAdvertiser = createBeaconAdvertiser
        self.startAdvertisingBeacon = startAdvertisingBeacon
        self.stopAdvertisingBeacon = stopAdvertisingBeacon
    }
}
