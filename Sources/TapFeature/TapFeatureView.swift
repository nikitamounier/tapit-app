import BeaconClient
import ComposableArchitecture
import FeedbackGeneratorClient
import IdentifiedCollections
import OrientationClient
import OrderedCollections
import P2PClient
import P2PEncodeDecode
import ProximitySensorClient
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers
import TapCore

public struct TapFeatureState: Equatable {
    public var profile: UserProfile
    public var presets: IdentifiedArrayOf<Preset>
    
    public var currentSection: Section
    
    public var selectedSocials: Set<Social.ID>
    public var selectedPresets: Set<Preset.ID>
    public var showTapSheet: Bool

    
    public var session: TapState?
    public var receivedProfile: UserProfile?
    
    
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
    
    case tapSheetShown(Bool)
    case tapButtonTapped
    case tap(TapAction)
}

public struct TapFeatureEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var beaconQueue: AnySchedulerOf<DispatchQueue>
    public var beacon: BeaconClient
    public var p2p: P2PClient
    public var p2pEncodeDecode: P2PEncodeDecode
    public var feedbackGenerator: FeedbackGeneratorClient
    public var proximitySensor: ProximitySensorClient
    public var orientation: OrientationClient
    public var dispatchNow: () -> DispatchTime
    public var openAppSettings: () -> Void
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        beaconQueue: AnySchedulerOf<DispatchQueue>,
        beacon: BeaconClient,
        p2p: P2PClient,
        p2pEncodeDecode: P2PEncodeDecode,
        feedbackGenerator: FeedbackGeneratorClient,
        proximitySensor: ProximitySensorClient,
        orientation: OrientationClient,
        dispatchNow: @escaping () -> DispatchTime,
        openAppSettings: @escaping () -> Void
    ) {
        self.mainQueue = mainQueue
        self.beaconQueue = beaconQueue
        self.beacon = beacon
        self.p2p = p2p
        self.p2pEncodeDecode = p2pEncodeDecode
        self.feedbackGenerator = feedbackGenerator
        self.proximitySensor = proximitySensor
        self.orientation = orientation
        self.dispatchNow = dispatchNow
        self.openAppSettings = openAppSettings
        
    }
}

// Selecting socials: When a user selects a preset, all the socials which are in that preset are selected. If a user deselects a social afterwards, the preset is deselected, but all the other socials remain selected.

public let tapFeatureReducer = Reducer<TapFeatureState, TapFeatureAction, TapFeatureEnvironment>.combine(
    tapReducer
        .optional()
        .pullback(
            state: \.session,
            action: .tap,
            environment: TapEnvironment.init
        ),
    
        .init { state, action, env in
            switch action {
            case let .goToSection(section):
                state.currentSection = section
                return .none
                
            case let .selectSocial(socialID):
                state.selectedSocials.insert(socialID)
                
                if state.selectedSocials.count == 1 {
                    state.session = TapState(userProfile: state.profile)
                    
                    return .merge(
                        Effect(value: .tap(.startP2P)),
                        Effect(value: .tap(.startBeacons))
                    )
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
                
                return state.selectedSocials.isEmpty ? Effect(value: .tap(.cancelAll)) : .none
                
            case let .selectPreset(presetID):
                state.selectedPresets.insert(presetID)
                state.selectedSocials.formUnion(state.presets[id: presetID]!.socials)
                
                // if this is first thing user selects
                if state.selectedPresets.count == 1 &&
                    state.selectedSocials.count == state.presets[id: presetID]!.socials.count {
                    state.session = TapState(userProfile: state.profile)
                    return .merge(
                        Effect(value: .tap(.startP2P)),
                        Effect(value: .tap(.startBeacons))
                    )
                }
                
                return .none
                
            case let .deselectPreset(presetID):
                state.selectedPresets.remove(presetID)
                if state.selectedPresets.isEmpty {
                    state.selectedSocials.subtract(state.presets[id: presetID]!.socials)
                    return state.selectedSocials.isEmpty ? Effect(value: .tap(.cancelAll)) : .none
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
                
            case .tapButtonTapped:
                guard !state.selectedSocials.isEmpty else { return .none }
                
                let profile = UserProfile(
                    id: state.profile.id,
                    name: state.profile.name,
                    profileImage: state.profile.profileImage,
                    socials: state.profile.socials.filter { state.selectedSocials.contains($0.id) }
                )
                state.session = TapState(userProfile: profile)
                
                return Effect(value: .tap(.tapButtonTapped))
                
            case let .tapSheetShown(showing):
                state.showTapSheet = showing
                return .none
                
            case let .tap(.receiveProfileResponse(profile, from: _)):
                state.receivedProfile = profile
                return .none
                
            case .tap(.finished), .tap(.tapErrorAlertDismissed):
                state.session = nil
                return .none
                
            case .tap:
                return .none
                
            }
        }
)

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
    
    public var body: some View {
        SwipeTabView(
            selection: viewStore.binding(
                get: \.currentSection.rawValue,
                send: { .goToSection(.init(rawValue: $0)!) }
            )
        ) {
            // socials
            ScrollView {
                SocialsGrid(
                    using: viewStore.profileSocials,
                    containsID: { viewStore.selectedSocials.contains($0) },
                    selectElement: { viewStore.send(.selectSocial($0)) },
                    deselectElement: { viewStore.send(.deselectSocial($0)) },
                    showGradientBorder: { viewStore.selectedSocials.contains($0) },
                    gradientDegrees: gradientDegrees,
                    textFromElement: Text.init,
                    imageFromElement: Image.init
                )
            }
            .swipeTabItem {
                Text("Socials")
                    .bold()
                    .foregroundColor(.blue)
            }
            
            // presets
            ScrollView {
                SocialsGrid(
                    using: viewStore.profilePresets,
                    containsID: { viewStore.selectedPresets.contains($0) },
                    selectElement: { viewStore.send(.selectPreset($0)) },
                    deselectElement: { viewStore.send(.deselectPreset($0)) },
                    showGradientBorder: { viewStore.selectedPresets.contains($0) },
                    gradientDegrees: gradientDegrees,
                    textFromElement: { Text($0.name) },
                    imageFromElement: { _ in Image(systemName: "command.circle.fill") }
                )
            }
            .swipeTabItem {
                Text("Presets")
                    .bold()
                    .foregroundColor(.blue)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                self.gradientDegrees = 360
            }
        }
        .backport.overlay(alignment: .bottom) {
            VStack {
                if !viewStore.selectedSocials.isEmpty {
                    Button(action: { viewStore.send(.tapButtonTapped) } ) {
                        Text("Share")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    .padding(.horizontal, 40)
                    .backport.background {
                        LinearGradient(gradient: .tapGradient, startPoint: .topLeading, endPoint: .trailing)
                    }
                    .clipShape(Capsule())
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.interactiveSpring(), value: viewStore.selectedSocials.isEmpty)
        }
        .sheet(isPresented: viewStore.binding(get: \.showTapSheet, send: TapFeatureAction.tapSheetShown)) {
            TapSheet(store: store)
        }
    }
}

extension CasePath where Root == TapFeatureAction, Value == TapAction {
    static let tap = Self(
        embed: TapFeatureAction.tap,
        extract: {
            guard case let .tap(tapAction) = $0 else { return nil }
            return tapAction
        }
    )
}

extension TapEnvironment {
    init(parentEnvironment: TapFeatureEnvironment) {
        self.init(
            mainQueue: parentEnvironment.mainQueue,
            beaconQueue: parentEnvironment.beaconQueue,
            beacon: parentEnvironment.beacon,
            p2p: parentEnvironment.p2p,
            p2pEncodeDecode: parentEnvironment.p2pEncodeDecode,
            feedbackGenerator: parentEnvironment.feedbackGenerator,
            proximitySensor: parentEnvironment.proximitySensor,
            orientation: parentEnvironment.orientation,
            dispatchNow: parentEnvironment.dispatchNow,
            openAppSettings: parentEnvironment.openAppSettings
        )
    }
}

struct TapFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        TapFeatureView(
            store: .init(
                initialState: .init(profile: .mock),
                reducer: tapFeatureReducer,
                environment: TapFeatureEnvironment(mainQueue: .immediate, beaconQueue: .failing, beacon: .failing, p2p: .failing, p2pEncodeDecode: .noop, feedbackGenerator: .failing, proximitySensor: .failing, orientation: .failing, dispatchNow: {.distantFuture}, openAppSettings: {})
            )
        )
    }
}
