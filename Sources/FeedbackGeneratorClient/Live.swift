import ComposableArchitecture
import UIKit

public extension FeedbackGeneratorClient {
    static var live: Self {
        let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        
        return Self(
            prepareSelectionGenerator: {
                .fireAndForget {
                    selectionFeedbackGenerator.prepare()
                }
            },
            prepareNotificationGenerator: {
                .fireAndForget {
                    notificationFeedbackGenerator.prepare()
                }
            },
            selectionChanged: {
                .fireAndForget {
                    selectionFeedbackGenerator.selectionChanged()
                }
            },
            notificationOccurred: { feedback in
                .fireAndForget {
                    switch feedback {
                    case .error:
                        return notificationFeedbackGenerator.notificationOccurred(.error)
                    case .success:
                        return notificationFeedbackGenerator.notificationOccurred(.success)
                    case .warning:
                        return notificationFeedbackGenerator.notificationOccurred(.warning)
                    }
                }
            }
        )
    }
}
