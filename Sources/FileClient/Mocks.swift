import ComposableArchitecture

public extension FileClient {
    static let noop = Self(
        load: { _ in .none },
        save: { _, _ in .none },
        delete: { _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        load: { _ in .failing("\(Self.self).load is unimplemented") },
        save: { _, _ in .failing("\(Self.self).save is unimplemented") },
        delete: { _ in .failing("\(Self.self).delete is unimplemented") }
    )
    #endif
}
