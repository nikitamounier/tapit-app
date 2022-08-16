import BeaconClient
import ComposableArchitecture
import HapticClient
import IdentifiedCollections
import Inject
import OrientationClient
import OrderedCollections
import MultipeerClient
import ProximitySensorClient
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

public struct TapFeatureState: Equatable {
  public var profile: UserProfile
  public var presets: IdentifiedArrayOf<Preset>
  public var currentSection: Section
  
  public var selectedSocials: Set<Social.ID>
  public var selectedPresets: Set<Preset.ID>
  
  public var showTapSheet: Bool
  
  public var receivedProfile: UserProfile?
  public var beacons: [Beacon] = []
  public var peers: [PeerID] = []
  public var errorAlert: AlertState<TapFeatureAction>?
  
  public struct Preset: Equatable, Identifiable {
    public let id = UUID()
    public var name: String
    public var socials: OrderedSet<Social.ID>
    
    public init(name: String, socials: OrderedSet<Social.ID>) {
      self.name = name
      self.socials = socials
    }
  }
  
  public enum Section: Int {
    case socials
    case presets
    case helloThere
  }
  
  public enum ErrorAlertType {
    case bluetoothWifi
    case closeness
  }
  
  public init(
    profile: UserProfile,
    presets: IdentifiedArrayOf<Preset> = [],
    currentSection: Section = .socials,
    selectedSocials: Set<Social.ID> = [],
    selectedPresets: Set<Preset.ID> = [],
    showTapSheet: Bool = false
  ) {
    self.profile = profile
    self.presets = presets
    self.currentSection = currentSection
    self.selectedSocials = selectedSocials
    self.selectedPresets = selectedPresets
    self.showTapSheet = showTapSheet
  }
}

public enum TapFeatureAction: Equatable {
  case goToSection(TapFeatureState.Section)
  case selectSocial(Social.ID)
  case deselectSocial(Social.ID)
  case selectPreset(TapFeatureState.Preset.ID)
  case deselectPreset(TapFeatureState.Preset.ID)
  
  case startTapSession
  case beaconsResponse([Beacon])
  case peerResponse(PeerID)
  case shareButtonPressed(Bool)
  case receivedProfileResponse(UserProfile)
  case showErrorAlert(reason: TapFeatureState.ErrorAlertType)
  case alertOKTapped
  
}

public struct TapFeatureEnvironment {
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var beacon: BeaconClient
  public var multipeer: MultipeerClient
  public var haptic: HapticClient
  public var proximitySensor: ProximitySensorClient
  public var orientation: OrientationClient
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    beacon: BeaconClient,
    multipeer: MultipeerClient,
    haptic: HapticClient,
    proximitySensor: ProximitySensorClient,
    orientation: OrientationClient
  ) {
    self.mainQueue = mainQueue
    self.beacon = beacon
    self.multipeer = multipeer
    self.haptic = haptic
    self.proximitySensor = proximitySensor
    self.orientation = orientation
    
  }
}

// Selecting socials: When a user selects a preset, all the socials which are in that preset are selected. If a user deselects a social afterwards, the preset is deselected, but all the other socials remain selected.

public let tapFeatureReducer = Reducer<TapFeatureState, TapFeatureAction, TapFeatureEnvironment>
  .init { state, action, environment in
    enum CancelTapID {}
    
    switch action {
    case let .goToSection(section):
      state.currentSection = section
      return .none
      
    case let .selectSocial(socialID):
      state.selectedSocials.insert(socialID)
      
      if state.selectedSocials.count == 1 {
        return .task { .startTapSession }
      }
      
      return .none
      
    case let .deselectSocial(socialID):
      state.selectedSocials.remove(socialID)
      if state.selectedPresets.isEmpty {
        return .none
      }
      
      // If a preset contains this social, deselect the preset
      state.selectedPresets.forEach { presetID in
        if state.presets[id: presetID]!.socials.contains(socialID) {
          state.selectedPresets.remove(presetID)
        }
      }
      
      return state.selectedSocials.isEmpty ? .cancel(id: CancelTapID.self) : .none
      
    case let .selectPreset(presetID):
      state.selectedPresets.insert(presetID)
      state.selectedSocials.formUnion(state.presets[id: presetID]!.socials)
      
      // if this is first thing user selects
      if state.selectedPresets.count == 1 &&
          state.selectedSocials.count == state.presets[id: presetID]!.socials.count {
        return .task { .startTapSession }
      }
      
      return .none
      
    case let .deselectPreset(presetID):
      state.selectedPresets.remove(presetID)
      if state.selectedPresets.isEmpty {
        state.selectedSocials.subtract(state.presets[id: presetID]!.socials)
        return state.selectedSocials.isEmpty ? Effect.cancel(id: CancelTapID.self) : .none
      }
      
      // Don't remove socials which are still in other selected presets
      let socialsToRemove = state.presets[id: presetID]!.socials
      let socialsToKeep: Set<Social.ID> = state.selectedPresets.reduce(into: []) { accum, otherPresetID in
        let commonSocials = state.presets[id: otherPresetID]!.socials.intersection(socialsToRemove)
        accum.formUnion(commonSocials)
      }
      
      // Remove socials, except those which are still in other presets
      state.selectedSocials.subtract(socialsToRemove.subtracting(socialsToKeep))
      
      return .none
      
    case .startTapSession:
      return .run { send in
        let major: UInt16 = .random(in: UInt16.min...UInt16.max)
        let minor: UInt16 = .random(in: UInt16.min...UInt16.max)
        
        await withThrowingTaskGroup(of: Void.self) { group in
          group.addTask {
            for try await beacons in await environment.beacon.start(major, minor) {
              await send(.beaconsResponse(beacons))
            }
          }
          
          group.addTask {
            let myPeerID = "\(String(format: "%016d-%016d", major, minor))"
            for await peer in await environment.multipeer.start(myPeerID) {
              await send(.peerResponse(peer))
            }
          }
        }
      } catch: { error, send in
        print("multipeer/beacon error: \(error.localizedDescription)")
        await send(.showErrorAlert(reason: .bluetoothWifi))
      }
      .cancellable(id: CancelTapID.self)
      
    case let .beaconsResponse(beacons):
      state.beacons = beacons
      return .none
      
    case let .peerResponse(peer):
      state.peers.append(peer)
      return .none
      
    case .shareButtonPressed(true):
      state.showTapSheet = true
      
      return .run { [profile = state.profile, peers = state.peers, beacons = state.beacons] send in
        await environment.haptic.prepare()
        
        async let isHorizontal = environment.orientation.horizontal()
        async let sensedProximity = environment.proximitySensor.sensedProximity()
        
        _ = await (isHorizontal, sensedProximity)
        
        // First see if there are any beacons in immediate surrounding. If not, see if beacons in "near" surrounding.
        // If multiple beacons in immediate/near surrounding, take one with lowest accuracy value (== closest).
        // In unlikely case that multiple beacons have same accuracy value, take one with highest RSSI (== signal strength).
        let immediate = beacons.filter { $0.proximity == .immediate }
        
        guard !beacons.isEmpty, !immediate.isEmpty || beacons.contains(where: { $0.proximity == .near })
        else {
          await send(.showErrorAlert(reason: .closeness))
          return
        }
        
        let closestBeacon: Beacon
        
        if !immediate.isEmpty {
          guard let immediateBeacon = immediate.max(by: { $0.accuracy > $1.accuracy }) ?? immediate.max(by: { $0.rssi > $1.rssi })
          else {
            await send(.showErrorAlert(reason: .closeness))
            return
          }
          closestBeacon = immediateBeacon
        } else {
          let near = beacons.filter { $0.proximity == .near }
          guard let nearBeacon = near.max(by: { $0.accuracy < $1.accuracy }) ?? immediate.max(by: { $0.rssi > $1.rssi })
          else {
            await send(.showErrorAlert(reason: .closeness))
            return
          }
          closestBeacon = nearBeacon
        }
        
        guard let closestPeer = peers
          .first(where: { $0.name == "\(String(format: "%016d-%016d", closestBeacon.major, closestBeacon.minor))" })
        else {
          await send(.showErrorAlert(reason: .bluetoothWifi))
          return
        }
        
        async let sendProfile: Void = environment.multipeer.send(profile, closestPeer)
        async let receiveProfile: UserProfile = environment.multipeer.receive(closestPeer)
        
        let (_, receivedProfile) = try await (sendProfile, receiveProfile)
        
        await environment.haptic.generateFeedback(.success)
        await send(.receivedProfileResponse(receivedProfile))
        
      } catch: { error, send in
        print("send/receive error: \(error.localizedDescription)")
        await send(.showErrorAlert(reason: .bluetoothWifi))
      }
      .cancellable(id: CancelTapID.self)
      
    case .shareButtonPressed(false):
      state.beacons = []
      state.peers = []
      state.showTapSheet = false
      state.selectedSocials = []
      state.selectedPresets = []
      
      return .cancel(id: CancelTapID.self)
      
    case let .receivedProfileResponse(profile):
      state.receivedProfile = profile
      return .cancel(id: CancelTapID.self)
      
    case let .showErrorAlert(reason: reason):
      let message: TextState
      switch reason {
      case .bluetoothWifi:
        message = TextState("An error occurred. Make sure that Bluetooth and Wifi are turned on, and that Tap It has permission to use them.")
      case .closeness:
        message = TextState("An error occurred. Make sure that you're close to the person you're tapping.")
      }
      
      state.showTapSheet = false
      
      state.errorAlert = AlertState(
        title: TextState("Error"),
        message: message,
        dismissButton: .default(TextState("OK"), action: .send(.alertOKTapped))
      )
      
      state.beacons = []
      state.peers = []
      state.selectedSocials = []
      state.selectedPresets = []
      
      // TODO: - Remove use of .merge(_:...)
      return .merge(.fireAndForget { await environment.haptic.generateFeedback(.error) }, .cancel(id: CancelTapID.self))
      
      
    case .alertOKTapped:
      state.errorAlert = nil
      return .none
    }
  }
  .debug()

public struct TapFeatureView: View {
  struct ViewState: Equatable {
    var profileSocials: [Social]
    var selectedSocials: Set<Social.ID>
    var profilePresets: [TapFeatureState.Preset]
    var selectedPresets: Set<TapFeatureState.Preset.ID>
    var currentSection: TapFeatureState.Section
    var showTapSheet: Bool
    
    init(state: TapFeatureState) {
      self.profileSocials = state.profile.socials
      self.selectedSocials = state.selectedSocials
      self.currentSection = state.currentSection
      self.profilePresets = Array(state.presets)
      self.selectedPresets = state.selectedPresets
      self.showTapSheet = state.showTapSheet
    }
  }
  
  let store: Store<TapFeatureState, TapFeatureAction>
  @ObservedObject var viewStore: ViewStore<ViewState, TapFeatureAction>
  
  public init(store: Store<TapFeatureState, TapFeatureAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
  }
  
  @State private var gradientDegrees: Double = 0
  @State private var gradientAlreadySet: Bool = false
  
  public var body: some View {
    SwipeTabView(
      selection: viewStore.binding(
        get: \.currentSection.rawValue,
        send: { .goToSection(.init(rawValue: $0)!) }
      )
    ) {
      LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
        ForEach(viewStore.profileSocials.indexed(), id: \.1.id) { index, social in
          Button {
            _ = viewStore.selectedSocials.contains(social.id) ? viewStore.send(.deselectSocial(social.id)) : viewStore.send(.selectSocial(social.id))
          } label: {
            RoundedRectangle(cornerRadius: 20)
              .rotatingGradientBorder(
                showBorder: viewStore.selectedSocials.contains(social.id),
                degrees: gradientDegrees
              )
              .aspectRatio(1.25, contentMode: .fit)
              .overlay(alignment: .center) {
                VStack {
                  //image(social)
                  EmptyView()
                    .padding(.bottom, 15)
                  Text(social: social)
                    .bold()
                }
              }
          }
          .padding(.leading, index.isMultiple(of: 2) ? 15 : 0)
          .padding(.trailing, !index.isMultiple(of: 2) ? 15 : 0)
        }
      }
    }
    .swipeTabItem {
      Text("Socials")
        .bold()
        .foregroundColor(.blue)
    }
    .onPageAppear {
      withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
        if !gradientAlreadySet {
          self.gradientDegrees = 360
          self.gradientAlreadySet = true
        }
      }
    }
    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
      ForEach(viewStore.profilePresets.indexed(), id: \.1.id) { index, preset in
        Button {
          _ = viewStore.selectedPresets.contains(preset.id) ? viewStore.send(.deselectPreset(preset.id)) : viewStore.send(.selectPreset(preset.id))
        } label: {
          RoundedRectangle(cornerRadius: 20)
            .rotatingGradientBorder(
              showBorder: viewStore.selectedPresets.contains(preset.id),
              degrees: gradientDegrees
            )
            .aspectRatio(1.25, contentMode: .fit)
            .overlay(alignment: .center) {
              VStack {
                EmptyView()
                  .padding(.bottom, 15)
                Text(preset.name)
                  .bold()
              }
            }
        }
        .padding(.leading, index.isMultiple(of: 2) ? 15 : 0)
        .padding(.trailing, !index.isMultiple(of: 2) ? 15 : 0)
      }
    }
    .swipeTabItem {
      Text("Presets")
        .bold()
        .foregroundColor(.blue)
    }
    .onDisappear {
      withAnimation(.default) { // `nil` doesn't stop the .repeatForever(), but this does
        self.gradientDegrees = 0
      }
    }
    .overlay(alignment: .bottom) {
      VStack {
        if !viewStore.selectedSocials.isEmpty {
          Button(action: { viewStore.send(.shareButtonPressed(true)) } ) {
            Text("Share")
              .foregroundColor(.white)
              .bold()
          }
          .padding()
          .padding(.horizontal, 40)
          .background {
            LinearGradient(gradient: .tapGradient, startPoint: .topLeading, endPoint: .trailing)
          }
          .clipShape(Capsule())
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .animation(.interactiveSpring(), value: viewStore.selectedSocials.isEmpty)
    }
    .sheet(isPresented: viewStore.binding(get: \.showTapSheet, send: TapFeatureAction.shareButtonPressed)) {
      TapSheet(store: store.scope(state: TapSheet.ViewState.init))
    }
    .alert(store.scope(state: \.errorAlert), dismiss: .alertOKTapped)
  }
}


//struct TapFeatureView_Previews: PreviewProvider {
//  static var previews: some View {
//    TapFeatureView(
//      store: .init(
//        initialState: .init(profile: .mock),
//        reducer: tapFeatureReducer,
//        environment: TapFeatureEnvironment(mainQueue: .immediate, beaconQueue: .unimplemented, beacon: .unimplemented, multipeer: .unimplemented, , haptic: .unimplemented, proximitySensor: .unimplemented, orientation: .unimplemented, openAppSettings: {})
//      )
//    )
//  }
//}
