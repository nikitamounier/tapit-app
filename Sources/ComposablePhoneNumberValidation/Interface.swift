import ComposableArchitecture
import PhoneNumberKit

public struct PhoneNumberValidationClient {
    public var create: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public var parse: (_ id: AnyHashable,
                       _ string: String,
                       _ region: String,
                       _ ignoreType: Bool) -> Effect<PhoneNumber, PhoneNumberError>
    
    public var end: (_ id: AnyHashable) -> Effect<Never, Never>
    
    public init(
        create: @escaping (_ id: AnyHashable) -> Effect<Never, Never>,
        parse: @escaping (_ id: AnyHashable, _ string: String, _ region: String, _ ignoreType: Bool) -> Effect<PhoneNumber, PhoneNumberError>,
        end: @escaping (_ id: AnyHashable) -> Effect<Never, Never>
    ) {
        self.create = create
        self.parse = parse
        self.end = end
    }
}
