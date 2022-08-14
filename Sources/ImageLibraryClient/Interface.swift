import SharedModels
import ComposableArchitecture

public struct ImageLibraryClient {
  public var openImagePicker: () -> Effect<ProfileImage, Error>
  
  public init(
    openImagePicker: @escaping () -> Effect<ProfileImage, Error>
  ) {
    self.openImagePicker = openImagePicker
  }
  
  public enum Error: Swift.Error {
    case noImagePicked
    case couldNotLoadImage
  }
}
