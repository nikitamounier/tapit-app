import ComposableArchitecture

public extension OpenSocialClient {
    static let noop = Self(
        open: { _, _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        open: { _, _ in .failing("\(Self.self).open is unimplemented")}
    )
    #endif
}
