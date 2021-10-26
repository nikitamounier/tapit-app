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
    static let failing = Self(
        browser: .failing,
        listener: .failing,
        connection: .failing
    )
}

public extension BrowserClient {
    static let failing = Self(
        create: { _, _ in .failing("\(Self.self).create is unimplemented") },
        startBrowsing: { _ in .failing("\(Self.self).startBrowsing is unimplemented") },
        stopBrowsing: { _ in .failing("\(Self.self).stopBrowsing is unimplemented") }
    )
}

public extension ListenerClient {
    static let failing = Self(
        create: { _, _, _ in .failing("\(Self.self).create is unimplemented") },
        startListening: { _ in .failing("\(Self.self).startListening is unimplemented") },
        stopListening: { _ in .failing("\(Self.self).stopListening is unimplemented") },
        uuid: {
            XCTFail("\(Self.self).uuid is unimplemented")
            return UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        }
    )
}

public extension ConnectionClient {
    static let failing = Self(
        create: { _, _ in .failing("\(Self.self).create is unimplemented") },
        startConnection: { _ in .failing("\(Self.self).startConnection is unimplemented") },
        stopConnection: { _ in .failing("\(Self.self).stopConnection is unimplemented") },
        sendMessage: { _, _, _ in .failing("\(Self.self).sendMessage is unimplemented") },
        connectionExists: { _ in
            XCTFail("\(Self.self).connectionExists is unimplemented")
            return false
            
        }
    )
}
#endif
