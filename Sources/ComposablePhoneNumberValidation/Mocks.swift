import Combine
import ComposableArchitecture

public extension PhoneNumberValidationClient {
  static let noop = Self(
    create: { _ in .none },
    parse: { _,_,_,_  in .none },
    end: { _ in .none }
  )
  
#if DEBUG
  static let unimplemented = Self(
    create: { _ in .unimplemented("\(Self.self).create") },
    parse: { _,_,_,_ in .unimplemented("\(Self.self).parse") },
    end: { _ in .unimplemented("\(Self.self).end") }
  )
#endif
}
