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
        .future { promise in
          do {
            let phoneNumber = try phoneNumberManagers[id]!.parse(string, withRegion: region, ignoreType: ignoreType)
            promise(.success(phoneNumber))
          } catch {
            promise(.failure(error as! PhoneNumberError))
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
