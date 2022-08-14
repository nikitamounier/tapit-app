import SwiftUI
import PagerTabStripView

public struct SwipeTabView<Content: View>: View {
  let selection: Binding<Int>?
  @ViewBuilder let content: () -> Content
  
  public init(selection: Binding<Int>? = nil, @ViewBuilder content: @escaping () -> Content) {
    self.selection = selection
    self.content = content
  }
  
  public var body: some View {
    PagerTabStripView(selection: selection, content: content)
      .pagerTabStripViewStyle(
        .scrollableBarButton(
          padding: EdgeInsets(
            top: 5,
            leading: 15,
            bottom: 0,
            trailing: 10
          ),
          tabItemSpacing: 15,
          tabItemHeight: 45
        )
      )
  }
}

public extension View {
  func swipeTabItem<Content: View>(_ swipeTabView: @escaping () -> Content) -> some View {
    return self.pagerTabItem(swipeTabView)
  }
  
  func onPageAppear(perform action: @escaping () -> Void) -> some View {
    return self.onPageAppear(perform: .some(action))
  }
}
