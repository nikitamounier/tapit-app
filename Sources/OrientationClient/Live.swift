import UIKit

extension OrientationClient {
  static let live = Self {
    await UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    let orientations = await NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
      .values
      .map { _ in () }
    
    _ = await orientations
      .first {
        let isFacedown = await UIDevice.current.orientation == .faceDown
        let isFaceUp = await UIDevice.current.orientation == .faceUp
        return isFacedown || isFaceUp
      }
    
    await UIDevice.current.endGeneratingDeviceOrientationNotifications()
    
    return true
  }
}
