import UIKit

public struct ProfileImage: Equatable {
  public var image: UIImage
  
  public init(_ image: UIImage) {
    self.image = image
  }
  
  public static func ==(lhs: ProfileImage, rhs: ProfileImage) -> Bool {
    return lhs.image.pngData() == rhs.image.pngData()
  }
}

extension ProfileImage: Codable {
  enum CodingKeys: CodingKey {
    case image
    case imageScale
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let scale = try container.decode(CGFloat.self, forKey: .imageScale)
    let imageData = try container.decode(UIImage.self, forKey: .image)
    
    self.image = UIImage(data: imageData, scale: scale)!
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.image, forKey: .image)
    try container.encode(self.image.scale, forKey: .imageScale)
  }
}

extension KeyedEncodingContainer {
  mutating func encode(_ value: UIImage, forKey key: KeyedEncodingContainer.Key) throws {
    guard let data = value.pngData() else {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(codingPath: [key], debugDescription: "Failed convert UIImage to data")
      )
    }
    try encode(data, forKey: key)
  }
}

extension KeyedDecodingContainer {
  func decode(_ type: UIImage.Type, forKey key: KeyedDecodingContainer.Key) throws -> Data {
    return try decode(Data.self, forKey: key)
  }
}
