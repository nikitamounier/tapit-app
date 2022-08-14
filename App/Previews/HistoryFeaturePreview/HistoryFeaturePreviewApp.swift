import HistoryFeature
import SwiftUI

@main
struct HistoryFeaturePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            HistoryView(
                store: .init(
                    initialState: .init(profiles: Array(repeating: .mock, count: 20)),
                    reducer: historyReducer,
                    environment: .init(
                        mainQueue: .main,
                        haptic: .noop,
                        isSentProfileExpired: .noop,
                        openSocial: .noop,
                        openAppSettings: {}
                    )
                )
            )
        }
    }
}
