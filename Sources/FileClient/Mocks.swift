import ComposableArchitecture

public extension FileClient {
  static let noop = Self(
    load: { _ in .none },
    save: { _, _ in .none },
    delete: { _ in .none }
  )
  
#if DEBUG
  static let unimplemented = Self(
    load: { _ in .unimplemented("\(Self.self).load") },
    save: { _, _ in .unimplemented("\(Self.self).save") },
    delete: { _ in .unimplemented("\(Self.self).delete") }
  )
#endif
}
