import ComposableArchitecture
import XCTestDynamicOverlay

public extension P2PClient {
    static let noop = Self(
        browser: .noop,
        listener: .noop,
        connection: .noop
    )
}

public extension BrowserClient {
    static let noop = Self(
        create: { _, _ in .none },
        startBrowsing: { _ in .none },
        stopBrowsing: { _ in .none }
    )
}

public extension ListenerClient {
    static let noop = Self(
        create: { _, _, _ in .none },
        startListening: { _ in .none },
        stopListening: { _ in .none },
        uuid: { UUID(uuidString: "00000000-0000-0000-0000-000000000000")! }
    )
}

public extension ConnectionClient {
    static let noop = Self(
        create: { _, _ in .none },
        startConnection: { _ in .none },
        stopConnection: { _ in .none },
        sendMessage: { _, _, _ in .none },
        connectionExists: { _ in false }
    )
}

#if DEBUG
public extension P2PClient {
    static let unimplemented = Self(
        browser: .unimplemented,
        listener: .unimplemented,
        connection: .unimplemented
    )
}

public extension BrowserClient {
    static let unimplemented = Self(
        create: { _, _ in .unimplemented("\(Self.self).create") },
        startBrowsing: { _ in .unimplemented("\(Self.self).startBrowsing") },
        stopBrowsing: { _ in .unimplemented("\(Self.self).stopBrowsing") }
    )
}

public extension ListenerClient {
    static let unimplemented = Self(
        create: { _, _, _ in .unimplemented("\(Self.self).create") },
        startListening: { _ in .unimplemented("\(Self.self).startListening") },
        stopListening: { _ in .unimplemented("\(Self.self).stopListening") },
        uuid: {
            XCTFail("\(Self.self).uuid")
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        }
    )
}

public extension ConnectionClient {
    static let unimplemented = Self(
        create: { _, _ in .unimplemented("\(Self.self).create") },
        startConnection: { _ in .unimplemented("\(Self.self).startConnection") },
        stopConnection: { _ in .unimplemented("\(Self.self).stopConnection") },
        sendMessage: { _, _, _ in .unimplemented("\(Self.self).sendMessage") },
        connectionExists: { _ in
            XCTFail("\(Self.self).connectionExists")
            return false
            
        }
    )
}
#endif
