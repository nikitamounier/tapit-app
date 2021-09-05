import Combine
import ComposableArchitecture
import CoreBluetooth
import CoreLocation
import OSLog

public extension BeaconClient {
    static var live = Self(
        detector: .live,
        advertiser: .live
    )
}

public extension DetectorClient {
    static var live: Self {
        let logger = Logger(subsystem: "Beacon", category: "DetectorClient")
        
        return Self(
            createBeaconDetector: { id, beaconUUID, identifier in
                .run { subscriber in
                    logger.debug("Creating beacon detector")
                    let locationManager = CLLocationManager()
                    let delegate = DetectorDelegate(subscriber)
                    let detectingRegion = CLBeaconRegion(uuid: beaconUUID, identifier: identifier)
                    
                    locationManager.delegate = delegate
                    
                    detectorDependencies[id] = DetectorDependencies(
                        locationManager: locationManager,
                        delegate: delegate,
                        detectingRegion: detectingRegion
                    )
                    
                    return AnyCancellable {
                        logger.debug("Deinitializing beacon detector")
                        detectorDependencies[id]?.locationManager.stopMonitoring(for: detectingRegion)
                        detectorDependencies[id]?.locationManager.stopRangingBeacons(
                            satisfying: detectingRegion.beaconIdentityConstraint
                        )
                        detectorDependencies[id] = nil
                    }
                }
            },
            startDetectingBeacons: { id in
                .fireAndForget {
                    logger.debug("Starting to detect beacons")
                    let detectingRegion = detectorDependencies[id]!.detectingRegion
                    
                    detectorDependencies[id]?.locationManager.startMonitoring(for: detectingRegion)
                    detectorDependencies[id]?.locationManager.startRangingBeacons(
                        satisfying: detectingRegion.beaconIdentityConstraint
                    )
                    logger.debug("Monitoring/ranging for beacons")
                }
            },
            stopDetectingBeacons: { id in
                .fireAndForget {
                    logger.debug("Stopping detecting beacons")
                    let detectingRegion = detectorDependencies[id]!.detectingRegion
                    
                    detectorDependencies[id]?.locationManager.stopMonitoring(for: detectingRegion)
                    detectorDependencies[id]?.locationManager.stopRangingBeacons(
                        satisfying: detectingRegion.beaconIdentityConstraint
                    )
                    
                    detectorDependencies[id] = nil
                }
            },
            uuid: UUID.init
        )
    }
}

public extension AdvertiserClient {
    static var live: Self {
        let logger = Logger(subsystem: "Beacon", category: "AdvertiserClient")
        
        return Self(
            createBeaconAdvertiser: { id, beaconUUID, major, minor, identifier in
                .run { subscriber in
                    logger.debug("Creating beacon advertiser")
                    let peripheralManager = CBPeripheralManager()
                    let delegate = AdvertiserDelegate(subscriber)
                    let advertisingRegion = CLBeaconRegion(
                        uuid: beaconUUID,
                        major: major,
                        minor: minor,
                        identifier: identifier
                    )
                    
                    peripheralManager.delegate = delegate
                    
                    advertiserDependencies[id] = AdvertiserDependencies(
                        peripheralManager: peripheralManager,
                        delegate: delegate,
                        advertisingRegion: advertisingRegion,
                        beaconPeripheralData: advertisingRegion.peripheralData(withMeasuredPower: nil))
                    
                    return AnyCancellable {
                        logger.debug("Deinitializing beacon advertiser")
                        advertiserDependencies[id]?.peripheralManager.stopAdvertising()
                        advertiserDependencies[id] = nil
                    }
                }
            },
            startAdvertisingBeacon: { id in
                .fireAndForget {
                    logger.debug("Starting to advertise beacon")
                    let data = advertiserDependencies[id]!.beaconPeripheralData
                    advertiserDependencies[id]?.peripheralManager.startAdvertising(data as? [String: Any])
                }
            },
            stopAdvertisingBeacon: { id in
                .fireAndForget {
                    logger.debug("Stopping advertising beacon")
                    advertiserDependencies[id]?.peripheralManager.stopAdvertising()
                    advertiserDependencies[id] = nil
                }
            },
            uuid: UUID.init,
            major: {
                .random(in: UInt16.min...UInt16.max)
            },
            minor: {
                .random(in: UInt16.min...UInt16.max)
            }
        )
    }
}

private var detectorDependencies: [AnyHashable: DetectorDependencies] = [:]
private var advertiserDependencies: [AnyHashable: AdvertiserDependencies] = [:]

private struct DetectorDependencies {
    let locationManager: CLLocationManager
    let delegate: DetectorDelegate
    let detectingRegion: CLBeaconRegion
}

private struct AdvertiserDependencies {
    let peripheralManager: CBPeripheralManager
    let delegate: AdvertiserDelegate
    let advertisingRegion: CLBeaconRegion
    let beaconPeripheralData: NSDictionary
}

private final class DetectorDelegate: NSObject, CLLocationManagerDelegate {
    let subscriber: Effect<DetectorClient.Event, Never>.Subscriber
    let logger: Logger = Logger(subsystem: "Beacon.DetectorDelegate", category: "AdvertiseClient")
    
    init(_ subscriber: Effect<DetectorClient.Event, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func locationManagerAuthorizationChanged(_ manager: CLLocationManager) {
        logger.debug("Location manager authorization changed to \(manager.authorizationStatus.debugDescription), privacy: .public)")
        subscriber.send(.authorizationChanged(manager.authorizationStatus))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.debug("Location manager failed with error \(error.localizedDescription, privacy: .public)")
        subscriber.send(.failed(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        logger.debug("Location manager ranged beacons \(beacons.map(\.rssi), privacy: .public)")
        subscriber.send(.ranged(beacons: beacons.map(Beacon.init(beacon:))))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        logger.debug("Location Manager failed ranging for beacon constraint with error: \(error.localizedDescription)")
        subscriber.send(.failedRanging(error))
    }
}

private final class AdvertiserDelegate: NSObject, CBPeripheralManagerDelegate {
    let subscriber: Effect<AdvertiserClient.Event, Never>.Subscriber
    let logger: Logger = Logger(subsystem: "Beacon.AdvertiserDelegate", category: "AdvertiseClient")
    
    init(_ subscriber: Effect<AdvertiserClient.Event, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        logger.debug("Peripheral manager updated state to \(peripheral.state.debugDescription, privacy: .public)")
        subscriber.send(.stateUpdated(peripheral.state))
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            logger.debug("Peripheral manager did not start advertising, error: \(error.localizedDescription, privacy: .public)")
            subscriber.send(.didNotStartAdvertising(error))
        } else {
            logger.debug("Peripheral manager started advertising")
        }
    }
}

extension CLAuthorizationStatus: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        @unknown default:
            return "unknown"
        }
    }
}

extension CBManagerState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unsupported"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        @unknown default:
            return "unknown"
        }
    }
}
