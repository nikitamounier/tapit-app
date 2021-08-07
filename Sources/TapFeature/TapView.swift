import BeaconClient
import ComposableArchitecture
import FeedbackGeneratorClient
import OrientationClient
import P2PClient
import ProximitySensorClient
import SharedModels
import SwiftUI

public struct TapState: Equatable {
    public var profile: UserProfile
    public var presets: [Preset]
    
    public var currentSection: Section
    
    public var selectedSocials: [Social]
    public var selectedPreset: Preset?
    public var finishedSelectingSocials: Bool
    
    
    public struct Preset: Equatable {
        public var name: String
        public var socials: [Social]
    }
    
    public enum Section {
        case socials
        case presets
    }
    
    public init(
        profile: UserProfile,
        presets: [TapState.Preset] = [],
        currentSection: TapState.Section = .socials,
        selectedSocials: [Social] = [],
        selectedPreset: TapState.Preset? = nil,
        finishedSelectingSocials: Bool = false
    ) {
        self.profile = profile
        self.presets = presets
        self.currentSection = currentSection
        self.selectedSocials = selectedSocials
        self.selectedPreset = selectedPreset
        self.finishedSelectingSocials = finishedSelectingSocials
    }
}

public enum TapAction: Equatable {
    case goToSection(TapState.Section)
    
    case selectSocial(Social)
    case deselectSocial(Social)
    case selectPreset(TapState.Preset)
    case deselectPreset
    
    case tapButtonTapped
}

public struct TapEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var beaconQueue: AnySchedulerOf<DispatchQueue>
    public var p2pQueue: AnySchedulerOf<DispatchQueue>
    public var beacon: BeaconClient
    public var p2p: P2PClient
    public var feedbackGenerator: FeedbackGeneratorClient
    public var proximitySensor: ProximitySensorClient
    public var orientation: OrientationClient
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        beaconQueue: AnySchedulerOf<DispatchQueue>,
        p2pQueue: AnySchedulerOf<DispatchQueue>,
        beacon: BeaconClient,
        p2p: P2PClient,
        feedbackGenerator: FeedbackGeneratorClient,
        proximitySensor: ProximitySensorClient,
        orientation: OrientationClient
    ) {
        self.mainQueue = mainQueue
        self.beaconQueue = beaconQueue
        self.p2pQueue = p2pQueue
        self.beacon = beacon
        self.p2p = p2p
        self.feedbackGenerator = feedbackGenerator
        self.proximitySensor = proximitySensor
        self.orientation = orientation
    }
}

public let tapReducer = Reducer<TapState, TapAction, TapEnvironment> { state, action, env in
    switch action {
    case let .goToSection(section):
        state.currentSection = section
        return .none
        
    case let .selectSocial(social):
        state.selectedSocials.append(social)
        if state.selectedPreset != nil {
            state.selectedPreset = nil
        }
        return .none
        
    case let .deselectSocial(social):
        guard let index = state.selectedSocials.firstIndex(of: social) else { return .none }
        state.selectedSocials.remove(at: index)
        return .none
        
    case let .selectPreset(preset):
        state.selectedPreset = preset
        state.selectedSocials = []
        return .none
        
    case .deselectPreset:
        state.selectedPreset = nil
        return .none
        
    case .tapButtonTapped:
        
        return .none
        
    }
}
