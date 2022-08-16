import ComposableArchitecture
import SharedModels
import SwiftUI
import SwiftUIHelpers
import UniformTypeIdentifiers
import struct Algorithms.IndexedCollection



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
  @ObservedObject var viewStore: ViewStore<SpringboardState, SpringboardAction>
  private let store: Store<SpringboardState, SpringboardAction>
  
  public init(store: Store<SpringboardState, SpringboardAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  private let columns: [GridItem] = [
    .init(.adaptive(minimum: 30, maximum: .infinity))
  ]
  
  public var body: some View {
    VStack {
      Text("My Socials")
        .font(.title3)
      Text("Tap to edit, hold and drag to move.")
        .font(.subheadline)
      LazyVGrid(columns: columns) {
        ForEach(viewStore.socials.indexed(), id: \.1) { index, social in
          Image(social: social)
            .overlay(alignment: .topTrailing) {
              if viewStore.isEditing {
                Button(action: { viewStore.send(.removeSocial(index: index)) }) {
                  Image(systemName: "x.circle")
                    .foregroundColor(.gray)
                }
              }
            }
            .wobble(viewStore.isEditing, amount: 50)
        }
      }
      
    }
  }
}
