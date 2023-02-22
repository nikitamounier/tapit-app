import ComposableArchitecture
import HapticClient
import OpenSocialClient
import OpenSocialFeature
import SharedModels
import SwiftUI

public struct SentProfileState: Equatable {
  public var profile: UserProfile
  public var openSocial: OpenSocialState
  
  public var sendDate: Date
  public var expirationInterval: Days?
}

public enum SentProfileAction: Equatable {
  case openSocial(OpenSocialAction)
  case setName(to: String)
  case addToCategory(ProfilesCategory)
  case removeFromCategory(ProfilesCategory)
  case removeSentProfile
}

public struct SentProfileEnvironment {
  public var haptic: HapticClient
  public var openSocial: OpenSocialClient
  public var openAppSettings: () -> Void
  
  public init(
    haptic: HapticClient,
    openSocial: OpenSocialClient,
    openAppSettings: @escaping () -> Void
  ) {
    self.haptic = haptic
    self.openSocial = openSocial
    self.openAppSettings = openAppSettings
  }
}

public let sentProfileReducer = Reducer<SentProfileState, SentProfileAction, SentProfileEnvironment>.combine(
  openSocialReducer
    .pullback(
      state: \.openSocial,
      action: .openSocial,
      environment: {
        OpenSocialEnvironment(
          openSocial: $0.openSocial,
          haptic: $0.haptic,
          openAppSettings: $0.openAppSettings
        )
      }
    ),
  
  Reducer { state, action, environment in
    switch action {
    case let .setName(name):
      state.profile.name = name
      return .none
      
    case .addToCategory:
      return .none
      
    case .removeFromCategory:
      return .none
      
    case .removeSentProfile:
      return .none
      
    case .openSocial:
      return .none
    }
  }
)

public struct SentProfileView: View {
  let store: Store<SentProfileState, SentProfileAction>
  @ObservedObject var viewStore: ViewStore<SentProfileState, SentProfileAction>
  
  init(store: Store<SentProfileState, SentProfileAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    HStack {
      Image(uiImage: viewStore.profile.profileImage.image)
      VStack {
        Text(viewStore.profile.name)
        socials
      }
    }
  }
  
  public var socials: some View {
    ForEach(viewStore.profile.socials, id: \.id) { social in
      switch social {
      case .phone:
        Image(social: social)
          .contextMenu {
            Button("Show contact") { viewStore.send(.openSocial(.open(social, .phone(.showUserContact))))}
            Button("Add contact") {
              viewStore.send(
                .openSocial(
                  .open(
                    social,
                    .phone(.addContact(name: viewStore.profile.name, image: viewStore.profile.profileImage.image))
                  )
                )
              )
            }
            Button("Call") { viewStore.send(.openSocial(.open(social, .phone(.call))))}
          }
        
      default:
        Button(action: { viewStore.send(.openSocial(.open(social, nil)))}) {
          Image(social: social)
        }
      }
    }
  }
}

struct SentProfileView_Previews: PreviewProvider {
  static var previews: some View {
    SentProfileView(store: .init(initialState: .init(profile: .mock, openSocial: .init(alert: nil), sendDate: .init()), reducer: sentProfileReducer, environment: .init(haptic: .noop, openSocial: .noop, openAppSettings: {})))
  }
}

extension CasePath where Root == SentProfileAction, Value == OpenSocialAction {
  static let openSocial = Self(
    embed: SentProfileAction.openSocial,
    extract: {
      guard case let .openSocial(openSocialAction) = $0 else { return nil }
      return openSocialAction
    }
  )
}

