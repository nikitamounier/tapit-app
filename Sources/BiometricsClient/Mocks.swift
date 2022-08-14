import ComposableArchitecture

public extension BiometricsClient {
  static let noop = Self(
    authenticate: { .none }
  )
}

#if DEBUG
public extension BiometricsClient {
  static let unimplemented = Self(
    authenticate: { .unimplemented("\(Self.self).authenticate")}
  )
}
#endif
