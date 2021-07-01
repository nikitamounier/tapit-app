import ComposableArchitecture
import UIKit

public extension ProximitySensorClient {
    static let live = Self(
        start: {
            UIDevice.current.isProximityMonitoringEnabled = true
            return NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)
                .filter { _ in UIDevice.current.proximityState == true }
                .map { _ in .inProximity }
                .eraseToEffect()
        },
        stop: .fireAndForget {
            UIDevice.current.isProximityMonitoringEnabled = false
        }
    )
}
