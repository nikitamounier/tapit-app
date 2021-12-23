import SwiftUI
import TapFeature

@main
struct TapFeaturePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            TapFeatureView(
                store: .init(
                    initialState: .init(
                        profile: .init(
                            id: .deadbeef,
                            name: "Bob",
                            profileImage: .mock,
                            socials: [.mockInstagram(), .mockSnapchat(), .mockTwitter(), .mockReddit(), .mockTikTok(), .mockWeChat(), .mockGithub(), .mockLinkedIn(), .mockAddress(), .mockEmail(), .mockPhone()]
                        )
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
        }
    }
}
