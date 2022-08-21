import MapKit

public struct Coordinate: Codable, Hashable, Equatable {
  public var latitude: Double
  public var longitude: Double
  
  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}


public extension CLLocationCoordinate2D {
  init(_ coordinates: Coordinate) {
    self.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
  }
}
