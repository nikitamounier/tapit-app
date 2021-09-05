import ComposableArchitecture
import XCTestDynamicOverlay

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
        stopAdvertisingBeacon: { _ in .none },
        uuid: { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! },
        major: { .zero },
        minor: { .zero }
    )
    
    #if DEBUG
    static let failing = Self(
        createBeaconAdvertiser: { _, _, _, _, _ in .failing("\(Self.self).createBeaconAdvertiser is unimplemented") },
        startAdvertisingBeacon: { _ in .failing("\(Self.self).startBeaconAdvertiser is unimplemented") },
        stopAdvertisingBeacon: { _ in .failing("\(Self.self).stopAdvertisingBeacon is unimplemented") },
        uuid: {
            XCTFail("\(Self.self).uuid is unimplemented")
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        },
        major: {
            XCTFail("\(Self.self).major is unimplemented")
            return .zero
        },
        minor: {
            XCTFail("\(Self.self).minor is unimplemented")
            return .zero
        }
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
    static let failing = Self(
        createBeaconDetector: { _, _, _ in .failing("\(Self.self).createBeaconDetector is unimplemented") },
        startDetectingBeacons: { _ in .failing("\(Self.self).startDetectingBeacons is unimplemented") },
        stopDetectingBeacons: { _ in .failing("\(Self.self).stopDetectingBeacons is unimplemented") },
        uuid: {
            XCTFail("\(Self.self).uuid is unimplemented")
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        }
    )
    #endif
}
