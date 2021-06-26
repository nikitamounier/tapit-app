import Combine
import ComposableArchitecture

public extension PhoneNumberValidationClient {
    static let noop = Self(
        create: { _ in .none },
        parse: { _,_,_,_  in .none },
        end: { _ in .none }
    )
}

#if DEBUG
public extension PhoneNumberValidationClient {
    static let failing = Self(
        create: { _ in .failing("\(Self.self).create is unimplemented") },
        parse: { _,_,_,_ in .failing("\(Self.self).parse is unimplemented") },
        end: { _ in .failing("\(Self.self).end is unimplemented") }
    )
}
#endif
