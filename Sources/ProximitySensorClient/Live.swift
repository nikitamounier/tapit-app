import UIKit

public extension ProximitySensorClient {
  static let live = Self {
    await UIDevice.current.startProximitySensor()
    
    let proximity = await NotificationCenter.default.publisher(for: UIDevice.proximityStateDidChangeNotification)
      .values
      .map { _ in () }
    
    _ = await proximity
      .first { await UIDevice.current.proximityState }
    
    await UIDevice.current.endGeneratingDeviceOrientationNotifications()
    
    return true
  }
}

extension UIDevice {
  func startProximitySensor() {
    self.isProximityMonitoringEnabled = true
  }
}

