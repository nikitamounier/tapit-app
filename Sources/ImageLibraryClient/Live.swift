import ComposableArchitecture
import PhotosUI
import SharedModels
import SwiftUI

public extension ImageLibraryClient {
  static let live = Self(
    openImagePicker: {
      .future { promise in
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let delegate: Optional = Delegate(with: promise)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = delegate
        
        picker.present()
      }
    }
  )
}

private final class Delegate: PHPickerViewControllerDelegate {
  let promise: (Result<ProfileImage, ImageLibraryClient.Error>) -> Void
  
  init(with promise: @escaping (Result<ProfileImage, ImageLibraryClient.Error>) -> Void) {
    self.promise = promise
  }
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    guard let image = results.first else {
      promise(.failure(.noImagePicked))
      return
    }
    
    guard image.itemProvider.canLoadObject(ofClass: UIImage.self) else {
      promise(.failure(.couldNotLoadImage))
      return
    }
    
    image.itemProvider.loadObject(ofClass: UIImage.self) { [unowned self] image, error in
      guard error != nil, let image = image as? UIImage else {
        self.promise(.failure(.couldNotLoadImage))
        return
      }
      
      let profileImage = ProfileImage(image)
      self.promise(.success(profileImage))
    }
  }
}

@available(iOSApplicationExtension, unavailable)
extension UIViewController {
  func present() {
    UIApplication.shared.windows
      .first(where: \.isKeyWindow)?
      .rootViewController?
      .present(self, animated: true, completion: nil)
  }
}
