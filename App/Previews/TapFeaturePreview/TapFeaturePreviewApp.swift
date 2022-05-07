import Inject
import SharedModels
import SwiftUI
import TapFeature


@main
struct TapFeaturePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            TapFeaturePreview()
        }
    }
}

struct TapFeaturePreview: View {
    @ObservedObject private var iO = Inject.observer
    
    var body: some View {
        NavigationView {
            TapFeatureView(
                store: .init(
                    initialState: .init(
                        profile: .init(
                            id: .deadbeef,
                            name: "Bob",
                            profileImage: .mock,
                            socials: [.mockInstagram(), .mockSnapchat(), .mockTwitter(), .mockReddit(), .mockTikTok(), .mockWeChat(), .mockGithub(), .mockLinkedIn(), .mockAddress(), .mockEmail(), .mockPhone()]
                        ),
                        presets: [
                            .init(name: "Friend", socials: [Social.mockInstagram().id, Social.mockTikTok().id]),
                            .init(name: "Potential?", socials: [Social.mockInstagram().id, Social.mockSnapchat().id, Social.mockPhone().id])
                        ],
                        selectedSocials: []
                    ),
                    reducer: tapFeatureReducer,
                    environment: .init(
                        mainQueue: .main,
                        beaconQueue: .immediate,
                        beacon: .noop,
                        p2p: .noop,
                        p2pEncodeDecode: .noop,
                        feedbackGenerator: .noop,
                        proximitySensor: .noop,
                        orientation: .noop,
                        dispatchNow: { .now() },
                        openAppSettings: {}
                    )
                )
            )
            .navigationTitle(Text("Tap It"))
        }
        .enableInjection()
    }
}
