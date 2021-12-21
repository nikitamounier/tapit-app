import ComposableArchitecture
import SharedModels
import SwiftUI

struct TapSheet: View {
    struct ViewState: Equatable {
        let receivedProfile: UserProfile?
        init(state: TapFeatureState) {
            self.receivedProfile = state.receivedProfile
        }
    }
    
    private let store: Store<TapFeatureState, TapFeatureAction>
    @ObservedObject private var viewStore: ViewStore<ViewState, TapFeatureAction>
    
    init(store: Store<TapFeatureState, TapFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: ViewState.init))
    }
    
    @State private var rotation: Double = 40
    
    var body: some View {
        switch viewStore.receivedProfile {
        case .none:
            ZStack {
                HandPhone()
                    .rotationEffect(.degrees(180 - rotation), anchor: .trailing)
                HandPhone()
                    .rotationEffect(.degrees(-rotation), anchor: .trailing)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    self.rotation = 0
                }
            }
        case .some:
            EmptyView()
        }
    }
}
