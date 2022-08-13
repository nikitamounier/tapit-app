import UIKit

public extension HapticClient {
  static var live: Self {
    let haptic = Haptic()
    return Self(
      prepare: { await haptic.prepare() },
      selectionResponse: { await haptic.selectionResponse() },
      generateFeedback: { await haptic.generateFeedback(for: $0) }
    )
  }
}

private final class Haptic {
  var feedbackGenerator: UINotificationFeedbackGenerator?
  var selectionOccuredGenerator: UISelectionFeedbackGenerator?
  
  @MainActor
  func prepare() {
    self.feedbackGenerator = UINotificationFeedbackGenerator()
    self.selectionOccuredGenerator = UISelectionFeedbackGenerator()
    self.feedbackGenerator?.prepare()
    self.selectionOccuredGenerator?.prepare()
  }
  
  @MainActor
  func selectionResponse() {
    self.selectionOccuredGenerator?.selectionChanged()
  }
  
  @MainActor
  func generateFeedback(for feedbackType: HapticClient.FeedbackType) {
    self.feedbackGenerator?.notificationOccurred(.init(rawValue: feedbackType.rawValue)!)
  }
}
