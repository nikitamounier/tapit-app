import ComposableArchitecture

extension FileClient {
  public static let previewValue = Self(
    load: { _ in throw CancellationError() },
    save: { _, _ in },
    delete: {_ in }
  )

  public static let testValue = Self(
    load: unimplemented("\(Self.self).load"),
    save: unimplemented("\(Self.self).save"),
    delete: unimplemented("\(Self.self).delete")
  )
}
