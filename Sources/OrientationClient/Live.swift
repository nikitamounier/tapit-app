import ComposableArchitecture
import UIKit

public extension OrientationClient {
    static var live = Self(
        start: {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            return NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                .map { _ in
                    switch UIDevice.current.orientation {
                    case .unknown:
                        return .unknown
                    case .portrait:
                        return .portrait
                    case .portraitUpsideDown:
                        return .portraitUpsideDown
                    case .landscapeLeft:
                        return .landscapeLeft
                    case .landscapeRight:
                        return .landscapeRight
                    case .faceUp:
                        return .faceUp
                    case .faceDown:
                        return .faceDown
                    @unknown default:
                        return .unknown
                    }
                }
                .eraseToEffect()
        },
        stop: .fireAndForget {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    )
}
