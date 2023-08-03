import CasePaths
import ComposableArchitecture
import SharedModels
import Styleguide
import SwiftUI

struct TapSheet: View {
  let store: StoreOf<TapFeature>
  
  @State private var rotation: Double = 60
  
  var body: some View {
    WithViewStore(store, observe: \.receivedProfile) { viewStore in
      if let profile = viewStore.state {
        HStack {
          Image(uiImage: profile.profileImage.image)
            .resizable()
          VStack {
            Text(profile.name)
            ForEach(profile.socials) { social in
              Text(social: social)
            }
          }
        }
      } else {
        GeometryReader { geo in
          ZStack {
            HStack {
              HandPhone()
                .fill(.tapGradient(startPoint: .topLeading, endPoint: .trailing))
                .aspectRatio(4, contentMode: .fit)
                .offset(x: 0, y: 30)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(.degrees(rotation), anchor: .leading)
                .frame(width: geo.size.width / 2 + 30, alignment: .leading)
              Spacer()
            }
            HStack {
              Spacer()
              HandPhone()
                .fill(.tapGradient(startPoint: .topLeading, endPoint: .trailing))
                .aspectRatio(4, contentMode: .fit)
                .offset(x: 0, y: 30)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .rotationEffect(.degrees(rotation), anchor: .trailing)
                .frame(width: geo.size.width / 2 + 30, alignment: .trailing)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .onAppear {
          withAnimation(
            .interpolatingSpring(
              mass: 0.1,
              stiffness: 1,
              damping: 1,
              initialVelocity: 0.9
            ).delay(0.25)
            
          ) {
            self.rotation = 0
          }
        }
        .navigationBarHidden(true)
        .drawingGroup()
      }
    }
  }
}
