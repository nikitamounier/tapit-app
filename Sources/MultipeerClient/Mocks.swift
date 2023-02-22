import Dependencies
import SharedModels

public extension MultipeerClient {
  static var previewValue = Self(
    start: { _ in .finished },
    sendProfile: { _, _ in return },
    receiveProfile: { _ in .mock },
    sendAck: { _ in return },
    receiveAck: { _ in return }
  )
  
  static let testValue = Self(
    start: unimplemented("\(Self.self).start", placeholder: .finished),
    sendProfile: unimplemented("\(Self.self).send", placeholder: ()),
    receiveProfile: unimplemented("\(Self.self).receive", placeholder: .mock),
    sendAck: unimplemented("\(Self.self).send", placeholder: ()),
    receiveAck: unimplemented("\(Self.self).receive", placeholder: ())
  )
}
