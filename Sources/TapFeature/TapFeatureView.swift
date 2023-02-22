import Algorithms
import BeaconClient
import ComposableArchitecture
import Dependencies
import HapticClient
import IdentifiedCollections
import Optics
import OrientationClient
import OrderedCollections
import MultipeerClient
import Prelude
import ProximitySensorClient
import SharedModels
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

public struct TapFeature: ReducerProtocol {
  public struct State: Equatable {
    public var profile: UserProfile
    public var presets: IdentifiedArrayOf<Preset>
    public var currentSection: Section
    
    public var selectedSocials: Set<Social.ID>
    public var selectedPresets: Set<Preset.ID>
    
    public var showTapSheet: Bool
    
    public var receivedProfile: UserProfile?
    public var beacons: [Beacon] = []
    public var peers: [PeerID] = []
    public var errorAlert: AlertState<Action>?
    
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
      showTapSheet: Bool = false,
      receivedProfile: UserProfile? = nil,
      beacons: [Beacon] = [],
      peers: [PeerID] = [],
      errorAlert: AlertState<Action>? = nil
    ) {
      self.profile = profile
      self.presets = presets
      self.currentSection = currentSection
      self.selectedSocials = selectedSocials
      self.selectedPresets = selectedPresets
      self.showTapSheet = showTapSheet
      self.receivedProfile = receivedProfile
      self.beacons = beacons
      self.peers = peers
      self.errorAlert = errorAlert
    }
  }
  
  public enum Action: Equatable {
    case goToSection(State.Section)
    case selectSocial(Social.ID)
    case deselectSocial(Social.ID)
    case selectPreset(State.Preset.ID)
    case deselectPreset(State.Preset.ID)
    
    case startTapSession
    case beaconsResponse([Beacon])
    case peerResponse(PeerID)
    case shareButtonPressed
    case dismissTapSheet
    case receivedProfileResponse(UserProfile)
    case showErrorAlert(reason: State.ErrorAlertType)
    case alertOKTapped
  }
  
  @Dependency(\.beaconClient) var beacon
  @Dependency(\.multipeerClient) var multipeer
  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.withRandomNumberGenerator) var withRandomNumberGenerator
  @Dependency(\.hapticClient) var haptic
  @Dependency(\.orientationClient.horizontal) var horizontal
  @Dependency(\.proximitySensorClient.sensedProximity) var sensedProximity
  
  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    enum CancelTapID {}
    
    switch action {
    case let .goToSection(section):
      state.currentSection = section
      return .none
      
    // Selecting socials: When a user selects a preset, all the socials which are in that preset are selected. If a user deselects a social afterwards, the preset is deselected, but all the other socials remain selected.
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
        return state.selectedSocials.isEmpty ? .cancel(id: CancelTapID.self) : .none
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
        await withTaskCancellation(id: CancelTapID.self, cancelInFlight: false) {
          let (major, minor) = withRandomNumberGenerator { generator in
            let major = generator.next(upperBound: UInt16.max)
            let minor = generator.next(upperBound: UInt16.max)
            return (major, minor)
          }
        
          await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
              for try await beacons in await beacon.start(major, minor) {
                await send(.beaconsResponse(beacons))
              }
            }
            
            group.addTask {
              let myPeerID = "\(String(format: "%016d-%016d", major, minor))"
              for await peer in await multipeer.start(myPeerID) {
                await send(.peerResponse(peer))
              }
            }
          }
        }
      } catch: { error, send in
        print("multipeer/beacon error: \(error.localizedDescription)")
        await send(.dismissTapSheet)
        await send(.showErrorAlert(reason: .bluetoothWifi))
      }
      .cancellable(id: CancelTapID.self)
      
    case let .beaconsResponse(beacons):
      state.beacons = beacons
      return .none
      
    case let .peerResponse(peer):
      state.peers.append(peer)
      return .none
      
    case .shareButtonPressed:
      state.showTapSheet = true
      
      return .run { [profile = state.profile, selectedSocials = state.selectedSocials, peers = state.peers, beacons = state.beacons] send in
        
        try await withTaskCancellation(id: CancelTapID.self, cancelInFlight: false) {
          await haptic.prepare()
          
          async let isHorizontal = horizontal()
          async let sensedProximity = sensedProximity()
          
          _ = await (isHorizontal, sensedProximity)
          
          // First see if there are any beacons in immediate surrounding. If not, see if beacons in "near" surrounding.
          // If multiple beacons in immediate/near surrounding, take one with lowest accuracy value (== closest).
          // In unlikely case that multiple beacons have same accuracy value, take one with highest RSSI (== signal strength).
          let immediate = beacons.filter { $0.proximity == .immediate }
          
          guard !beacons.isEmpty, (!immediate.isEmpty || beacons.contains(where: { $0.proximity == .near }))
          else {
            await send(.dismissTapSheet)
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
          
          let userProfile = profile
            |> \.socials .~ profile.socials.removingAll { !selectedSocials.contains($0.id) }
          
          async let sendProfile: Void = multipeer.sendProfile(userProfile, closestPeer)
          async let receiveProfile: UserProfile = multipeer.receiveProfile(closestPeer)
          async let receiveAck: Void = multipeer.receiveAck(closestPeer)
          
          let (_, receivedProfile) = try await (sendProfile, receiveProfile)
          
          
          async let sendAck: Void = multipeer.sendAck(closestPeer)
          _ = try await (receiveAck, sendAck)
          
          print("send and received ack")
          
          await haptic.generateFeedback(.success)
          await send(.receivedProfileResponse(receivedProfile))
          }
        } catch: { error, send in
          print("send/receive error: \(error.localizedDescription)")
          await send(.dismissTapSheet)
          await send(.showErrorAlert(reason: .bluetoothWifi))
      }
      .cancellable(id: CancelTapID.self)
      
    case let .receivedProfileResponse(profile):
      state.receivedProfile = profile
      return .none
      
    case .dismissTapSheet:
      state.showTapSheet = false
      state.beacons = []
      state.peers = []
      state.selectedSocials = []
      state.selectedPresets = []
      
      return .cancel(id: CancelTapID.self)
      
    case let .showErrorAlert(reason: reason):
      let message: TextState
      switch reason {
      case .bluetoothWifi:
        message = TextState("An error occurred. Make sure that Bluetooth and Wifi are turned on, and that Tap It has permission to use them.")
      case .closeness:
        message = TextState("An error occurred. Make sure that you're close to the person you're tapping.")
      }
      
      state.errorAlert = AlertState<Action>(
        title: TextState("Error"),
        message: message,
        dismissButton: .default(TextState("OK"), action: .send(.alertOKTapped))
      )
      
      state.beacons = []
      state.peers = []
      state.selectedSocials = []
      state.selectedPresets = []
      
      // TODO: - Remove use of .merge(_:...)
      return .merge(
        .fireAndForget { await haptic.generateFeedback(.error) },
        .cancel(id: CancelTapID.self)
      )
      
      
    case .alertOKTapped:
      state.errorAlert = nil
      return .none
    }
  }
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

public struct TapFeatureView: View {
  struct ViewState: Equatable {
    var profileSocials: [Social]
    var selectedSocials: Set<Social.ID>
    var profilePresets: [TapFeature.State.Preset]
    var selectedPresets: Set<TapFeature.State.Preset.ID>
    var currentSection: TapFeature.State.Section
    var showTapSheet: Bool
    
    init(state: TapFeature.State) {
      self.profileSocials = state.profile.socials
      self.selectedSocials = state.selectedSocials
      self.currentSection = state.currentSection
      self.profilePresets = Array(state.presets)
      self.selectedPresets = state.selectedPresets
      self.showTapSheet = state.showTapSheet
    }
  }
  
  let store: StoreOf<TapFeature>
  @ObservedObject var viewStore: ViewStore<ViewState, TapFeature.Action>
  
  public init(store: StoreOf<TapFeature>) {
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
      ScrollView(showsIndicators: false) {
        // Socials
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
          ForEach(viewStore.profileSocials.indexed(), id: \.1.id) { index, social in
            Button {
              _ = viewStore.selectedSocials.contains(social.id) ? viewStore.send(.deselectSocial(social.id)) : viewStore.send(.selectSocial(social.id))
            } label: {
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(viewStore.selectedSocials.contains(social.id) ? Color(social: social) : .tertiary)
                .aspectRatio(1.25, contentMode: .fit)
                .overlay(alignment: .center) {
                  VStack {
                    //image(social)
                    Image("Whatsapp")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .padding([.trailing, .leading], 55)
                      //.padding(.bottom, 5)
                    Text(social: social)
                      .foregroundColor(.primary)
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
          withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
            if !gradientAlreadySet {
              self.gradientDegrees = 100
              self.gradientAlreadySet = true
            }
          }
        }
      
      // Presets
      ScrollView(showsIndicators: false) {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
          ForEach(viewStore.profilePresets.indexed(), id: \.1.id) { index, preset in
            Button {
              _ = viewStore.selectedPresets.contains(preset.id) ? viewStore.send(.deselectPreset(preset.id)) : viewStore.send(.selectPreset(preset.id))
            } label: {
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(viewStore.selectedPresets.contains(preset.id) ? .purple : .tertiary)
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
      }
        .swipeTabItem {
          Text("Presets")
            .bold()
            .foregroundColor(.blue)
        }
    }
    .onDisappear {
      withAnimation(.default) { // `nil` doesn't stop the .repeatForever(), but this does
        self.gradientDegrees = 0
      }
    }
    .overlay(alignment: .bottom) {
      VStack {
        if !viewStore.selectedSocials.isEmpty {
          Button(action: { viewStore.send(.shareButtonPressed) } ) {
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
    .sheet(isPresented: viewStore.binding(get: \.showTapSheet, send: { $0 ? .shareButtonPressed : .dismissTapSheet })) {
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
