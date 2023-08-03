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

let nikita: [Social] = [
  .mockInstagram(name: "nikitamounier"),
//  .mockPhone(),
  .mockEmail(name: "nikita.mounier@gmail.com"),
  .mockTwitter(name: "nikitamounier")
]

let receivedProfile = UserProfile(id: UUID(), name: "Nikita Mounier", profileImage: ProfileImage(UIImage(systemName: "person.fill")!), socials: nikita)

let state = TapFeature.State(
  profile: .mock,
  presets: [.init(name: "Public", socials: [UserProfile.mock.socials[0].id, UserProfile.mock.socials[2].id, UserProfile.mock.socials[7].id])],
  currentSection: .socials,
  selectedSocials: [],
  selectedPresets: [],
  showTapSheet: false,
  receivedProfile: nil,
  errorAlert: nil
)

struct TapFeaturePreview: View {
    
    var body: some View {
        NavigationView {
            TapFeatureView(
              store: .init(initialState: state, reducer: TapFeature())
            )
            .navigationTitle(Text("Tap It"))
          #if DEBUG
            .onAppear {
              UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
            }
          #endif
        }
    }
}
