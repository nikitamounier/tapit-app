import ComposableArchitecture
import UIKit

public extension ProximitySensorClient {
    static let live = Self(
        start: {
            UIDevice.current.isProximityMonitoringEnabled = true
            return NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)
                .map { _ in UIDevice.current.proximityState ? .inProximity : .notInProximity }
                .eraseToEffect()
        },
        stop: .fireAndForget {
            UIDevice.current.isProximityMonitoringEnabled = false
        }
    )
}
