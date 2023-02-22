import Dependencies

public extension HapticClient {
  static var previewValue = Self(
    prepare: { },
    selectionResponse: { },
    generateFeedback: { _ in }
  )
  
  static var testValue = Self(
    prepare: unimplemented("\(Self.self).prepare"),
    selectionResponse: unimplemented("\(Self.self).selectionResponse"),
    generateFeedback: unimplemented("\(Self.self).generateFeedback")
  )
}
