public struct HapticClient {
  public var prepare: @Sendable () async -> Void
  public var selectionResponse: @Sendable () async  -> Void
  public var generateFeedback: @Sendable (FeedbackType) async -> Void
  
  public init(
    prepare: @escaping @Sendable () async -> Void,
    selectionResponse: @escaping @Sendable () async  -> Void,
    generateFeedback: @escaping  @Sendable (FeedbackType) async -> Void
  ) {
    self.prepare = prepare
    self.selectionResponse = selectionResponse
    self.generateFeedback = generateFeedback
    
  }
  
  
  public enum FeedbackType: Int {
    case success
    case warning
    case error
  }
}
