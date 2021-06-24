//
//  File.swift
//
//
//  Created by Nikita Mounier on 21/06/2021.
//

import MapKit

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        self.latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        self.longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
    }
}

