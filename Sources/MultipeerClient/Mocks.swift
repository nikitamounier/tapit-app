import SharedModels
import XCTestDynamicOverlay

public extension MultipeerClient {
  static let noop = Self(
    start: { _ in .finished },
    send: { _, _ in return },
    receive: { _ in .mock }
  )
}

#if DEBUG
public extension MultipeerClient {
  static let unimplemented = Self(
    start: XCTUnimplemented("\(Self.self).start", placeholder: .finished),
    send: XCTUnimplemented("\(Self.self).send", placeholder: ()),
    receive: XCTUnimplemented("\(Self.self).receive", placeholder: .mock)
  )
}
#endif
