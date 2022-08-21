import SharedModels
import XCTestDynamicOverlay

public extension MultipeerClient {
  static let noop = Self(
    start: { _ in .finished },
    sendProfile: { _, _ in return },
    receiveProfile: { _ in .mock },
    sendAck: { _ in return },
    receiveAck: { _ in return }
  )
}

#if DEBUG
public extension MultipeerClient {
  static let unimplemented = Self(
    start: XCTUnimplemented("\(Self.self).start", placeholder: .finished),
    sendProfile: XCTUnimplemented("\(Self.self).send", placeholder: ()),
    receiveProfile: XCTUnimplemented("\(Self.self).receive", placeholder: .mock),
    sendAck: XCTUnimplemented("\(Self.self).send", placeholder: ()),
    receiveAck: XCTUnimplemented("\(Self.self).receive", placeholder: ())
  )
}
#endif
