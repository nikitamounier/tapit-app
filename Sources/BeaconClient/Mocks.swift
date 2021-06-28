import ComposableArchitecture

public extension BeaconClient {
    static let noop = Self(
        createBeaconDetector: { _, _, _ in .none },
        startDetectingBeacons: { _ in .none },
        stopDetectingBeacons: { _ in .none },
        createBeaconAdvertiser: { _, _, _, _, _ in .none },
        startAdvertisingBeacon: { _ in .none },
        stopAdvertisingBeacon: { _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        createBeaconDetector: { _, _, _ in .failing("\(Self.self).createBeaconDetector is unimplemented") },
        startDetectingBeacons: { _ in .failing("\(Self.self).startDetectingBeacons is unimplemented") },
        stopDetectingBeacons: { _ in .failing("\(Self.self).stopDetectingBeacons is unimplemented") },
        createBeaconAdvertiser: { _, _, _, _, _ in .failing("\(Self.self).createBeaconAdvertiser is unimplemented") },
        startAdvertisingBeacon: { _ in .failing("\(Self.self).startAdvertisingBeacon is unimplemented") },
        stopAdvertisingBeacon: { _ in .failing("\(Self.self).stopAdvertisingBeacons is unimplemented") }
    )
    #endif
}
