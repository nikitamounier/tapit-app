import ComposableArchitecture

public extension BeaconClient {
    static let noop = Self(
        detector: .noop,
        advertiser: .noop
    )
    
    #if DEBUG
    static let failing = Self(
        detector: .failing,
        advertiser: .failing
    )
    #endif
}

public extension AdvertiserClient {
    static let noop = Self(
        createBeaconAdvertiser: { _, _, _, _, _ in .none },
        startAdvertisingBeacon: { _ in .none },
        stopAdvertisingBeacon: { _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        createBeaconAdvertiser: { _, _, _, _, _ in .failing("\(Self.self).createBeaconAdvertiser is unimplemented") },
        startAdvertisingBeacon: { _ in .failing("\(Self.self).startBeaconAdvertiser is unimplemented") },
        stopAdvertisingBeacon: { _ in .failing("\(Self.self).stopAdvertisingBeacon is unimplemented") }
    )
    #endif
}


public extension DetectorClient {
    static let noop = Self(
        createBeaconDetector: { _, _, _ in .none },
        startDetectingBeacons: { _ in .none },
        stopDetectingBeacons: { _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        createBeaconDetector: { _, _, _ in .failing("\(Self.self).createBeaconDetector is unimplemented") },
        startDetectingBeacons: { _ in .failing("\(Self.self).startDetectingBeacons is unimplemented") },
        stopDetectingBeacons: { _ in .failing("\(Self.self).stopDetectingBeacons is unimplemented") }
    )
    #endif
}
