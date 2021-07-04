import ComposableArchitecture

public extension FeedbackGeneratorClient {
    static let noop = Self(
        prepareSelectionGenerator: { .none },
        prepareNotificationGenerator: { .none },
        selectionChanged: { .none },
        notificationOccurred: { _ in .none }
    )
    
    #if DEBUG
    static let failing = Self(
        prepareSelectionGenerator: { .failing("\(Self.self).prepareSelectionGenerator is unimplemented") },
        prepareNotificationGenerator: { .failing("\(Self.self).prepareNotificationGenerator is unimplemented") },
        selectionChanged: { .failing("\(Self.self).selectionChanged is unimplemented") },
        notificationOccurred: { _ in .failing("\(Self.self).notificationOccured is unimplemented") }
    )
    #endif
}
