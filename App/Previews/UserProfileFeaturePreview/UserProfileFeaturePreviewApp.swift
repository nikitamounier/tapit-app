import SpringboardFeature
import SwiftUI

@main
struct UserProfileFeaturePreviewApp: App {
    var body: some Scene {
        WindowGroup {
            UserProfileView(
                store: .init(
                    initialState: .init(profile: .mock),
                    reducer: userProfileReducer,
                    environment: UserProfileEnvironment.init()
                )
            )
        }
    }
}
