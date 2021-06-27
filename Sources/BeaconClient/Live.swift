import Combine
import ComposableArchitecture
import CoreBluetooth
import CoreLocation
import OSLog

extension BeaconClient {
    static var live: Self {
        let logger = Logger(subsystem: "", category: "BeaconClient")
        
        return Self(
            createBeaconDetector: { id, beaconUUID, identifier in
                logger.log(level: .debug, "Creating beacon detector")
                
                return .run { subscriber in
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
                        logger.log(level: .debug, "Deinitializing beacon detector")
                        detectorDependencies[id] = nil
                    }
                }
            },
            startDetectingBeacons: { id in
                .fireAndForget {
                    logger.log(level: .debug, "Starting to detect beacons")
                    let detectingRegion = detectorDependencies[id]!.detectingRegion
                    
                    detectorDependencies[id]?.locationManager.startMonitoring(for: detectingRegion)
                    detectorDependencies[id]?.locationManager.startRangingBeacons(
                        satisfying: detectingRegion.beaconIdentityConstraint
                    )
                    logger.log(level: .debug, "Monitoring/ranging for beacons")
                }
            },
            stopDetectingBeacons: { id in
                .fireAndForget {
                    logger.log(level: .debug, "Stopping detecting beacons")
                    let detectingRegion = detectorDependencies[id]!.detectingRegion
                    
                    detectorDependencies[id]?.locationManager.stopMonitoring(for: detectingRegion)
                    detectorDependencies[id]?.locationManager.stopRangingBeacons(
                        satisfying: detectingRegion.beaconIdentityConstraint
                    )
                    
                    detectorDependencies[id] = nil
                }
            },
            createBeaconAdvertiser: { id, beaconUUID, major, minor, identifier in
                .run { subscriber in
                    logger.log(level: .debug, "Creating beacon advertiser")
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
                        logger.log(level: .debug, "Deinitializing beacon advertiser")
                        advertiserDependencies[id] = nil
                    }
                }
            },
            startAdvertisingBeacon: { id in
                .fireAndForget {
                    logger.log(level: .debug, "Starting to advertise beacon")
                    let data = advertiserDependencies[id]!.beaconPeripheralData
                    advertiserDependencies[id]?.peripheralManager.startAdvertising(data as? [String: Any])
                }
            },
            stopAdvertisingBeacon: { id in
                .fireAndForget {
                    logger.log(level: .debug, "Stopping advertising beacon")
                    advertiserDependencies[id]?.peripheralManager.stopAdvertising()
                    advertiserDependencies[id] = nil
                }
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
    let subscriber: Effect<BeaconClient.BeaconAction.DetectorAction, Never>.Subscriber
    
    init(_ subscriber: Effect<BeaconClient.BeaconAction.DetectorAction, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        subscriber.send(.didChangeAuthorization(manager.authorizationStatus))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subscriber.send(.didFail(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        subscriber.send(.didRange(beacons: beacons))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        subscriber.send(.didFailRanging(error))
    }
}

private final class AdvertiserDelegate: NSObject, CBPeripheralManagerDelegate {
    let subscriber: Effect<BeaconClient.BeaconAction.AdvertiserAction, Never>.Subscriber
    
    init(_ subscriber: Effect<BeaconClient.BeaconAction.AdvertiserAction, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        subscriber.send(.didUpdateState(peripheral.state))
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            subscriber.send(.didNotStartAdvertising(error))
        }
    }
}
