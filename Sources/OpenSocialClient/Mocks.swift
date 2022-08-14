import ComposableArchitecture

public extension OpenSocialClient {
  static let noop = Self(
    open: { _, _ in .none }
  )
  
#if DEBUG
  static let unimplemented = Self(
    open: { _, _ in .unimplemented("\(Self.self).open")}
  )
#endif
}
