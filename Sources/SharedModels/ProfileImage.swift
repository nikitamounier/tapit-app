//
//  File.swift
//  
//
//  Created by Nikita Mounier on 21/06/2021.
//

import UIKit

public struct ProfileImage {
    public var image: UIImage
    
    public init(_ image: UIImage) {
        self.image = image
    }
}

extension ProfileImage: Codable {
    enum CodingKeys: CodingKey {
        case image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(UIImage.self, forKey: .image)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.image, forKey: .image)
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
    func decode(_ type: UIImage.Type, forKey key: KeyedDecodingContainer.Key) throws -> UIImage {
        let imageData = try decode(Data.self, forKey: key)
        if let image = UIImage(data: imageData) {
          return image
        } else {
          throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [key], debugDescription: "Failed load UIImage from decoded data")
          )
        }
      }
}
