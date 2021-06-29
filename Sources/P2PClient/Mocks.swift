import ComposableArchitecture

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
        startBrowsing: { _, _ in .none },
        stopBrowsing: { _ in .none }
    )
}

public extension ListenerClient {
    static let noop = Self(
        create: { _, _, _, _, _ in .none },
        startListening: { _, _ in .none },
        stopListening: { _ in .none }
    )
}

public extension ConnectionClient {
    static let noop = Self(
        create: { _, _ in .none },
        startConnection: { _, _ in .none },
        stopConnection: { _ in .none },
        sendMessage: { _, _, _ in .none }
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
        startBrowsing: { _, _ in .failing("\(Self.self).startBrowsing is unimplemented") },
        stopBrowsing: { _ in .failing("\(Self.self).stopBrowsing is unimplemented") }
    )
}

public extension ListenerClient {
    static let failing = Self(
        create: { _, _, _, _, _ in .failing("\(Self.self).create is unimplemented") },
        startListening: { _, _ in .failing("\(Self.self).startListening is unimplemented") },
        stopListening: { _ in .failing("\(Self.self).stopListening is unimplemented") }
    )
}

public extension ConnectionClient {
    static let failing = Self(
        create: { _, _ in .failing("\(Self.self).create is unimplemented") },
        startConnection: { _, _ in .failing("\(Self.self).startConnection is unimplemented") },
        stopConnection: { _ in .failing("\(Self.self).stopConnection is unimplemented") },
        sendMessage: { _, _, _ in .failing("\(Self.self).sendMessage is unimplemented") }
    )
}
#endif
