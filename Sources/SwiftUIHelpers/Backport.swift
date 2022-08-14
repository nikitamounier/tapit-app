import SwiftUI

public struct Backport<Content> {
  public let content: Content
  
  public init(_ content: Content) {
    self.content = content
  }
}

public extension View {
  var backport: Backport<Self> {
    return Backport(self)
  }
}

public extension Backport where Content: View {
  @ViewBuilder
  func overlay<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
    if #available(iOS 15.0, *) {
      self.content.overlay(alignment: alignment, content: content)
    } else {
      self.content.overlay(content(), alignment: alignment)
    }
  }
  
  @ViewBuilder
  func background<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
    if #available(iOS 15.0, *) {
      self.content.background(content: content)
    } else {
      self.content.background(content(), alignment: alignment)
    }
  }
}
