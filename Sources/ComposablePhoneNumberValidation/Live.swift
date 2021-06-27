import Combine
import ComposableArchitecture
import Dispatch
import PhoneNumberKit

public extension PhoneNumberValidationClient {
    static let live = Self(
        create: { id in
            .fireAndForget {
                phoneNumberManagers[id] = PhoneNumberKit()
            }
            .eraseToEffect()
        },
        parse: { id, string, region, ignoreType in
            .future { callback in
                do {
                    let phoneNumber = try phoneNumberManagers[id]!.parse(string, withRegion: region, ignoreType: ignoreType)
                    callback(.success(phoneNumber))
                } catch {
                    callback(.failure(error as! PhoneNumberError))
                }
            }
            .eraseToEffect()
        },
        end: { id in
            .fireAndForget {
                phoneNumberManagers[id] = nil
            }
            .eraseToEffect()
        }
    )
}

private var phoneNumberManagers: [AnyHashable: PhoneNumberKit] = [:]
