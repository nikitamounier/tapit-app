import BottomSheet
import SwiftUI
import SwiftUIHelpers

public enum SheetPosition: CGFloat, CaseIterable {
  case top = 0.975
  case middle = 0.4
  case hidden = 0
  
  static let animation: Animation = .spring(
    response: 0.3,
    dampingFraction: 0.75,
    blendDuration: 1
  )
}

public extension Backport where Content: View {
  @ViewBuilder
  func bottomMenu<HeaderContent: View, MainContent: View>(
    sheetPosition: Binding<SheetPosition>,
    @ViewBuilder header: @escaping () -> HeaderContent,
    scrollingMain: () -> ScrollView<MainContent>
  ) -> some View {
    if #available(iOS 15, *) {
      self.content
    } else {
      let options: [BottomSheet.Options] = [
        .appleScrollBehavior,
        .noBottomPosition,
        .backgroundBlur(effect: .systemThinMaterial),
        .tapToDissmiss,
        .swipeToDismiss,
        .animation(SheetPosition.animation),
      ]
      
      self.content.bottomSheet(
        bottomSheetPosition: sheetPosition,
        options: options,
        headerContent: header,
        mainContent: { scrollingMain().content }
      )
      
      self.content.bottomSheet(
        bottomSheetPosition: sheetPosition,
        options: options,
        headerContent: header,
        mainContent: { scrollingMain().content }
      )
    }
  }
  
  @ViewBuilder
  func bottomMenu<HeaderContent: View, MainContent: View>(
    sheetPosition: Binding<SheetPosition>,
    @ViewBuilder header: @escaping () -> HeaderContent,
    @ViewBuilder main: @escaping () -> MainContent
  ) -> some View {
    let options: [BottomSheet.Options] = [
      .allowContentDrag,
      .noBottomPosition,
      .backgroundBlur(effect: .systemThinMaterial),
      .tapToDissmiss,
      .swipeToDismiss,
      .animation(SheetPosition.animation)
    ]
    
    self.content.bottomSheet(
      bottomSheetPosition: sheetPosition,
      options: options,
      headerContent: header,
      mainContent: main
    )
  }
}


@available(iOS 15, *)










struct BottomMenu_Previews: PreviewProvider {
  struct Preview: View {
    @State private var sheetPosition: SheetPosition = .hidden
    @State private var showSheet = false
    
    var body: some View {
      VStack {
        Color.blue
          .onTapGesture {
            withAnimation(SheetPosition.animation) {
              sheetPosition = .middle
            }
          }
        Color.red
          .onTapGesture {
            showSheet = true
          }
      }
      .backport.bottomMenu(sheetPosition: $sheetPosition, header: {
        Text("Hello there")
      }, scrollingMain: {
        ScrollView {
          LazyVStack {
            ForEach(0..<100) { n in
              Label("The number is \(n)", systemImage: "circle")
                .font(.title2)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
              Divider().padding(.leading)
            }
          }
        }
      })
      .eraseToAnyView()
    }
    
#if DEBUG
    @ObservedObject var iO = injectionObserver
#endif
  }
  
  static var previews: some View {
    Preview()
      .edgesIgnoringSafeArea(.bottom)
      .environment(\.colorScheme, .light)
  }
}
