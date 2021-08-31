import ComposableArchitecture
import SharedModels
import UniformTypeIdentifiers

public struct SpringboardState: Equatable {
    public var socials: [Social]
    public var isEditing: Bool
    
    
    public init(
        socials: [Social],
        isEditing: Bool = false
    ) {
        self.socials = socials
        self.isEditing = isEditing
    }
}

public enum SpringboardAction: Equatable {
    case toggleEditing
    case moveSocial(from: Int, toOffset: Int)
    case removeSocial(index: Int)
}

public struct SpringBoardEnvironment {}

public let springboardReducer = Reducer<SpringboardState, SpringboardAction, SpringBoardEnvironment> { state, action, _ in
    switch action {
    case .toggleEditing:
        state.isEditing.toggle()
        return .none
    
    case .moveSocial:
        return .none
        
    case .removeSocial:
        return .none
    }
}

public struct SpringboardView: View {
    
}
