import XCTestDynamicOverlay

public extension HapticClient {
  static let noop = Self(
    prepare: { },
    selectionResponse: { },
    generateFeedback: { _ in }
  )
}

#if DEBUG
public extension HapticClient {
  static let unimplemented = Self(
    prepare: XCTUnimplemented("\(Self.self).prepare"),
    selectionResponse: XCTUnimplemented("\(Self.self).selectionResponse"),
    generateFeedback: XCTUnimplemented("\(Self.self).generateFeedback")
  )
}
#endif
