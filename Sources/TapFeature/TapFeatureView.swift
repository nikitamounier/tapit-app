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
import TapCore

public struct TapFeatureState: Equatable {
    public var profile: UserProfile
    public var presets: IdentifiedArrayOf<Preset>
    
    public var currentSection: Section
    
    public var selectedSocials: Set<Social.ID>
    public var selectedPresets: Set<Preset.ID>
    public var finishedSelectingSocials: Bool
    
    public var session: TapState?
    
    
    public struct Preset: Equatable, Identifiable {
        public let id = UUID()
        public var name: String
        public var socials: OrderedSet<Social.ID>
    }
    
    public enum Section {
        case socials
        case presets
    }
    
    public init(
        profile: UserProfile,
        presets: IdentifiedArrayOf<Preset> = [],
        currentSection: Section = .socials,
        selectedSocials: Set<Social.ID> = [],
        selectedPresets: Set<Preset.ID> = [],
        finishedSelectingSocials: Bool = false
    ) {
        self.profile = profile
        self.presets = presets
        self.currentSection = currentSection
        self.selectedSocials = selectedSocials
        self.selectedPresets = selectedPresets
        self.finishedSelectingSocials = finishedSelectingSocials
    }
}

public enum TapFeatureAction: Equatable {
    case goToSection(TapFeatureState.Section)
    
    case selectSocial(Social.ID)
    case deselectSocial(Social.ID)
    case selectPreset(TapFeatureState.Preset.ID)
    case deselectPreset(TapFeatureState.Preset.ID)
    
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
                
                return .none
                
            case let .selectPreset(presetID):
                state.selectedPresets.insert(presetID)
                state.selectedSocials.formUnion(state.presets[id: presetID]!.socials)
                
                return .none
                
            case let .deselectPreset(presetID):
                state.selectedPresets.remove(presetID)
                if state.selectedPresets.isEmpty {
                    state.selectedSocials.subtract(state.presets[id: presetID]!.socials)
                    return .none
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
                
                return .merge(
                    Effect(value: .tap(.startBeacons)),
                    Effect(value: .tap(.startP2P))
                )
                
            case .tap(.finished), .tap(.tapErrorAlertDismissed):
                state.session = nil
                return .none
                
            case .tap:
                return .none
                
            }
        }
)

public struct TapFeatureView: View {
    let store: Store<TapFeatureState, TapFeatureAction>
    @ObservedObject var viewStore: ViewStore<TapFeatureState, TapFeatureAction>
    
    public init(store: Store<TapFeatureState, TapFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    @State private var gradientDegrees: Double = 0
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(viewStore.profile.socials) { social in
                    Button(action: { viewStore.send(.selectSocial(social.id)) }) {
                        RoundedRectangle(cornerRadius: 10)
                            .rotatingGradientBorder(
                                showBorder: viewStore.selectedSocials.contains(social.id), degrees: gradientDegrees
                            )
                            .foregroundColor(.primary)
                            .overlayView(alignment: .center) {
                                VStack {
                                    Image(social: social)
                                        .padding(.bottom, 15)
                                    Text(social: social)
                                        .bold()
                                }
                            }
                    }
                    .padding()
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    self.gradientDegrees = 360
                }
            }
            
            if !viewStore.selectedSocials.isEmpty {
                Button(action: { viewStore.send(.tapButtonTapped)} ) {
                    Capsule(style: .circular)
                        .fill(.tapGradient())
                        .overlayView {
                            Text("Share")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                .transition(.move(edge: .bottom))
            }
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

extension View {
    @ViewBuilder
    func overlayView<Content: View>(alignment: Alignment = .center, content: @escaping () -> Content) -> some View {
        if #available(iOS 15.0, *) {
            self.overlay(alignment: alignment, content: content)
        } else {
            self.overlay(content(), alignment: alignment)
        }
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
