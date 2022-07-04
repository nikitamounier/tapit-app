import ComposableArchitecture
import XCTestDynamicOverlay

public extension BeaconClient {
    static let noop = Self(
        detector: .noop,
        advertiser: .noop
    )
    
    #if DEBUG
    static let unimplemented = Self(
        detector: .unimplemented,
        advertiser: .unimplemented
    )
    #endif
}

public extension AdvertiserClient {
    static let noop = Self(
        createBeaconAdvertiser: { _, _, _, _, _ in .none },
        startAdvertisingBeacon: { _ in .none },
        stopAdvertisingBeacon: { _ in .none },
        uuid: { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! },
        major: { .zero },
        minor: { .zero }
    )
    
    #if DEBUG
    static let unimplemented = Self(
        createBeaconAdvertiser: { _, _, _, _, _ in .unimplemented("\(Self.self).createBeaconAdvertiser") },
        startAdvertisingBeacon: { _ in .unimplemented("\(Self.self).startBeaconAdvertiser") },
        stopAdvertisingBeacon: { _ in .unimplemented("\(Self.self).stopAdvertisingBeacon") },
        uuid: XCTUnimplemented("\(Self.self).uuid")
        major: XCTUnimplemented("\(Self.self).major")
        minor: XCTUnimplemented("\(Self.self).minor")
    )
    #endif
}


public extension DetectorClient {
    static let noop = Self(
        createBeaconDetector: { _, _, _ in .none },
        startDetectingBeacons: { _ in .none },
        stopDetectingBeacons: { _ in .none },
        uuid: { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
    )
    
    #if DEBUG
    static let unimplemented = Self(
        createBeaconDetector: { _, _, _ in .unimplemented("\(Self.self).createBeaconDetector") },
        startDetectingBeacons: { _ in .unimplemented("\(Self.self).startDetectingBeacons") },
        stopDetectingBeacons: { _ in .unimplemented("\(Self.self).stopDetectingBeacons") },
        uuid: XCTUnimplemented("\(Self.self).uuid")
    )
    #endif
}
