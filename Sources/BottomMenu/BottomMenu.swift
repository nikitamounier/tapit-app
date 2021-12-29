import BottomSheet
import SwiftUI

public extension View {
    func bottomMenu<HeaderContent: View, MainContent: View>(
        sheetPosition: Binding<SheetPosition>,
        @ViewBuilder header: @escaping () -> HeaderContent,
        scrollingMain: () -> ScrollView<MainContent>
    ) -> some View {
        
        self.bottomSheet(
            bottomSheetPosition: sheetPosition,
            options: [.noBottomPosition, .appleScrollBehavior, .backgroundBlur(effect: .systemThinMaterial), .tapToDissmiss, .swipeToDismiss, .animation(SheetPosition.animation)],
            headerContent: header,
            mainContent: { scrollingMain().content }
        )
    }
    
    func bottomMenu<HeaderContent: View, MainContent: View>(
        sheetPosition: Binding<SheetPosition>,
        @ViewBuilder header: @escaping () -> HeaderContent,
        @ViewBuilder main: @escaping () -> MainContent
    ) -> some View {
        self.bottomSheet(
            bottomSheetPosition: sheetPosition,
            options: [.noBottomPosition, .allowContentDrag, .backgroundBlur(effect: .systemThinMaterial), .tapToDissmiss, .swipeToDismiss, .animation(SheetPosition.animation)],
            headerContent: header,
            mainContent: main
        )
    }
}

public enum SheetPosition: CGFloat, CaseIterable {
    case top = 0.975
    case middle = 0.4
    case hidden = 0
    
    static let animation: Animation = .spring(response: 0.3, dampingFraction: 0.75, blendDuration: 1)
}

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
            .bottomMenu(sheetPosition: $sheetPosition, header: {
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
        }
    }
    
    static var previews: some View {
        Preview()
            .edgesIgnoringSafeArea(.bottom)
            .environment(\.colorScheme, .light)
    }
}
