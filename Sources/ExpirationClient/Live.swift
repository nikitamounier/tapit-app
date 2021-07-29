import Foundation

public extension ExpirationClient {
    static let live = Self(
        isExpired: { sendDate, expirationInterval in
            let interval = Calendar.current.dateComponents([.day], from: sendDate).day ?? 0
            if interval > expirationInterval.amount {
                return true
            } else {
                return false
            }
        }
    )
}
