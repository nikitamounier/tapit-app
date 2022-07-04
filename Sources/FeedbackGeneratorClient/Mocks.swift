import ComposableArchitecture

public extension FeedbackGeneratorClient {
    static let noop = Self(
        prepareSelectionGenerator: { .none },
        prepareNotificationGenerator: { .none },
        selectionChanged: { .none },
        notificationOccurred: { _ in .none }
    )
    
    #if DEBUG
    static let unimplemented = Self(
        prepareSelectionGenerator: { .unimplemented("\(Self.self).prepareSelectionGenerator") },
        prepareNotificationGenerator: { .unimplemented("\(Self.self).prepareNotificationGenerator") },
        selectionChanged: { .unimplemented("\(Self.self).selectionChanged") },
        notificationOccurred: { _ in .unimplemented("\(Self.self).notificationOccured") }
    )
    #endif
}
