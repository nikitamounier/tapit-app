import Foundation
import CoreLocation

public struct Beacon: Hashable {
    public let uuid: UUID
    public let major: UInt16
    public let minor: UInt16
    public let proximity: CLProximity
    public let accuracy: CLLocationAccuracy
    public let rssi: Int
    public let timestamp: Date
    
    public init(
        uuid: UUID,
        major: UInt16,
        minor: UInt16,
        proximity: CLProximity,
        accuracy: CLLocationAccuracy,
        rssi: Int,
        timestamp: Date
    ) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.proximity = proximity
        self.accuracy = accuracy
        self.rssi = rssi
        self.timestamp = timestamp
    }
    
    public init(beacon: CLBeacon) {
        self.uuid = beacon.uuid
        self.major = UInt16(truncating: beacon.major)
        self.minor = UInt16(truncating: beacon.minor)
        self.proximity = beacon.proximity
        self.accuracy = beacon.accuracy
        self.rssi = beacon.rssi
        self.timestamp = beacon.timestamp
    }
}
