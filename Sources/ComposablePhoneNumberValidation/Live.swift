import Combine
import ComposableArchitecture
import Dispatch
import PhoneNumberKit

extension PhoneNumberValidationClient {
    static let live = Self(
        create: { id in
            .fireAndForget {
                phoneNumberManagers[id] = PhoneNumberKit()
            }
            .subscribe(on: validationQueue)
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
            .subscribe(on: validationQueue)
            .eraseToEffect()
        },
        end: { id in
            .fireAndForget {
                phoneNumberManagers[id] = nil
            }
            .subscribe(on: validationQueue)
            .eraseToEffect()
        }
    )
}

private var phoneNumberManagers: [AnyHashable: PhoneNumberKit] = [:]
private let validationQueue = DispatchQueue(label: "phoneNumberValidationQueue")
