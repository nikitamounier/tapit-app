import ComposableArchitecture
import HistoryFeature
import SharedModels
import SwiftUI

public struct AppView: View {
    public init() {}
    
    public var body: some View {
        HistoryView(
            store: Store(
                initialState: HistoryState(
                    profiles: .init(Array(repeating: .mock, count: 100)),
                    selectedProfile: nil,
                    categories: []),
                reducer: historyReducer,
                environment: HistoryEnvironment(
                    feedbackGenerator: .live,
                    openSocial: .live,
                    openAppSettings: {}
                )
            )
        )
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
