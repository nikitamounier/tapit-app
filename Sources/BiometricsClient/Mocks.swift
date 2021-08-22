import ComposableArchitecture

public extension BiometricsClient {
    static let noop = Self(
        authenticate: { .none }
    )
}

#if DEBUG
public extension BiometricsClient {
    static let failing = Self(
        authenticate: { .failing("\(Self.self).authenticate is unimplemented")}
    )
}
#endif
