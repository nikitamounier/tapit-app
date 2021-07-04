import ComposableArchitecture

public struct FeedbackGeneratorClient {
    public enum FeedbackType {
        case error
        case success
        case warning
    }
    
    public var prepareSelectionGenerator: () -> Effect<Never, Never>
    public var prepareNotificationGenerator: () -> Effect<Never, Never>
    
    public var selectionChanged: () -> Effect<Never, Never>
    public var notificationOccurred: (_ feedback: FeedbackType) -> Effect<Never, Never>
    
    public init(
        prepareSelectionGenerator: @escaping () -> Effect<Never, Never>,
        prepareNotificationGenerator: @escaping () -> Effect<Never, Never>,
        selectionChanged: @escaping () -> Effect<Never, Never>,
        notificationOccurred: @escaping (FeedbackType) -> Effect<Never, Never>
    ) {
        self.prepareSelectionGenerator = prepareSelectionGenerator
        self.prepareNotificationGenerator = prepareNotificationGenerator
        self.selectionChanged = selectionChanged
        self.notificationOccurred = notificationOccurred
    }
}
