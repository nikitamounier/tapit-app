import Dependencies

extension BeaconClient {
  public static var previewValue = Self { _, _ in .finished() }
  
  public static var testValue = Self(start: XCTUnimplemented("\(Self.self).contains", placeholder: .finished()))
}

