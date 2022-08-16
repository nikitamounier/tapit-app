import CoreBluetooth
import ComposableArchitecture
import CoreLocation
import Foundation

public extension BeaconClient {
  static var live: Self {
    let beacon = BeaconManager()
    
    return Self { await beacon.start(major: $0, minor: $1)}
  }
}

public enum BeaconError: Error, Equatable {
  case deniedAuthorization
}

private final class BeaconManager {
  @BeaconActor var delegate: Delegate?
  
  @BeaconActor @Box var locationManager: CLLocationManager?
  @BeaconActor @Box var peripheralManager: CBPeripheralManager?
  
  @BeaconActor
  func start(major: UInt16, minor: UInt16) async -> AsyncThrowingStream<[Beacon], Error> {
    return AsyncThrowingStream { continuation in
      let detectingRegion = CLBeaconRegion(
        uuid: UUID(uuidString: "3281D6D1-F2E7-4436-80C0-4EF265331538")!,
        identifier: Bundle.main.bundleIdentifier!
      )
      
      let advertisingRegion = CLBeaconRegion(
        uuid: UUID(uuidString: "3281D6D1-F2E7-4436-80C0-4EF265331538")!,
        major: major,
        minor: minor,
        identifier: Bundle.main.bundleIdentifier!
      )
      
      self.delegate = Delegate(
        detectorAuthorizationChanged: { [locationManager = UncheckedSendable($locationManager)] auth in
          
          print("Detector authorization changed: \(auth)")
          switch auth {
          case .authorizedAlways, .authorizedWhenInUse:
            
            guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
                  CLLocationManager.isRangingAvailable()
            else {
              continuation.finish(throwing: BeaconError.deniedAuthorization)
              return
            }
            
            locationManager.wrappedValue.wrappedValue?.startMonitoring(for: detectingRegion)
            locationManager.wrappedValue.wrappedValue?.startRangingBeacons(satisfying: detectingRegion.beaconIdentityConstraint)
            
            break
            
          case .restricted, .denied:
            continuation.finish(throwing: BeaconError.deniedAuthorization)
            
          case .notDetermined:
            break
            
          @unknown default:
            fatalError()
          }
        },
        detectorFailed: { error in
          print("Detector Failed: \(error)")
          continuation.finish(throwing: error)
        },
        detectorRangedBeacons: { beacons in
          print("Detector ranged beacons: \(beacons)")
          continuation.yield(beacons)
        },
        advertiserStateChanged: { [peripheralManager = UncheckedSendable($peripheralManager)] state in
          print("Advertiser state changed: \(state)")
          switch state {
          case .poweredOn:
            peripheralManager.wrappedValue.wrappedValue?.startAdvertising(
              advertisingRegion.peripheralData(withMeasuredPower: nil) as? [String: Any]
            )
            
            
          case .unsupported, .unauthorized, .poweredOff:
            continuation.finish(throwing: BeaconError.deniedAuthorization)
            
          case .resetting, .unknown:
            break
            
          @unknown default:
            break
          }
        },
        advertiserFailed: { error in
          print("Advertiser failed: \(error)")
          continuation.finish(throwing: error)
        }
      )
      
      continuation.onTermination = { @Sendable [locationManager = UncheckedSendable($locationManager), peripheralManager = UncheckedSendable($peripheralManager)] _ in
        print("continuation terminated")
        locationManager.wrappedValue.wrappedValue?.stopMonitoring(for: detectingRegion)
        locationManager.wrappedValue.wrappedValue?.stopRangingBeacons(satisfying: detectingRegion.beaconIdentityConstraint)
        peripheralManager.wrappedValue.wrappedValue?.stopAdvertising()
      }
      
      self.locationManager = CLLocationManager()
      self.peripheralManager = CBPeripheralManager()
      
      locationManager?.delegate = self.delegate
      peripheralManager?.delegate = self.delegate
      
      locationManager?.requestWhenInUseAuthorization()
      
    }
  }
}

private final class Delegate: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate, Sendable {
  let detectorAuthorizationChanged: @Sendable (CLAuthorizationStatus) -> Void
  let detectorFailed: @Sendable (Error) -> Void
  let detectorRangedBeacons: @Sendable ([Beacon]) -> Void
  
  let advertiserStateChanged: @Sendable (CBManagerState) -> Void
  let advertiserFailed: @Sendable (Error) -> Void
  
  init(
    detectorAuthorizationChanged: @Sendable @escaping (CLAuthorizationStatus) -> Void,
    detectorFailed: @Sendable @escaping (Error) -> Void,
    detectorRangedBeacons: @Sendable @escaping ([Beacon]) -> Void,
    advertiserStateChanged: @Sendable @escaping (CBManagerState) -> Void,
    advertiserFailed: @Sendable @escaping (Error) -> Void
  ) {
    self.detectorAuthorizationChanged = detectorAuthorizationChanged
    self.detectorFailed = detectorFailed
    self.detectorRangedBeacons = detectorRangedBeacons
    self.advertiserStateChanged = advertiserStateChanged
    self.advertiserFailed = advertiserFailed
  }
  
  // Detector

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("authorization changed: \(manager.authorizationStatus)")
    self.detectorAuthorizationChanged(manager.authorizationStatus)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("authorization changed: \(status)")
    self.detectorAuthorizationChanged(status)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    self.detectorFailed(error)
  }
  
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    self.detectorFailed(error)
  }

  
  func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    let beacons = beacons.map {
      let accuracy = $0.accuracy.sign == .minus ? .infinity : $0.accuracy // if accuracy negative means it could not be determined
      return Beacon(
        major: $0.major as! UInt16,
        minor: $0.minor as! UInt16,
        proximity: Beacon.Proximity(rawValue: $0.proximity.rawValue)!,
        accuracy: accuracy,
        rssi: $0.rssi
      )
    }
    self.detectorRangedBeacons(beacons)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
    self.detectorFailed(error)
  }
  
  // Advertiser
  
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    self.advertiserStateChanged(peripheral.state)
  }
  
  func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    if let error {
      self.advertiserFailed(error)
    }
  }
}

@propertyWrapper
private final class Box<Value> {
  var wrappedValue: Value
  
  var projectedValue: Box<Value> { self }
  
  init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
}
