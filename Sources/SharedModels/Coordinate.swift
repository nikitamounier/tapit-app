//
//  File.swift
//
//
//  Created by Nikita Mounier on 21/06/2021.
//

import MapKit

public struct Coordinate: Codable {
    public var latitude: Double
    public var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Coordinate {
    public init(_ locationCoordinate: CLLocationCoordinate2D) {
        self.latitude = locationCoordinate.latitude
        self.longitude = locationCoordinate.longitude
    }
}

extension CLLocationCoordinate2D {
    public init(_ coordinate: Coordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
