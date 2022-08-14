import Algorithms
import SwiftUI

struct SocialsGrid<Data>: View
where
Data: RandomAccessCollection,
Data.Index: BinaryInteger,
Data.Element: Identifiable {
  
  let data: Data
  let contains: (Data.Element.ID) -> Bool
  let select: (Data.Element.ID) -> Void
  let deselect: (Data.Element.ID) -> Void
  let showGradientBorder: (Data.Element.ID) -> Bool
  var degrees: Double
  let text: (Data.Element) -> Text
  let image: (Data.Element) -> Image
  
  init(
    using data: Data,
    containsID contains: @escaping (Data.Element.ID) -> Bool,
    selectElement select: @escaping (Data.Element.ID) -> Void,
    deselectElement deselect: @escaping (Data.Element.ID) -> Void,
    showGradientBorder: @escaping (Data.Element.ID) -> Bool,
    gradientDegrees degrees: Double,
    textFromElement text: @escaping (Data.Element) -> Text,
    imageFromElement image: @escaping (Data.Element) -> Image
  ) {
    self.data = data
    self.contains = contains
    self.select = select
    self.deselect = deselect
    self.showGradientBorder = showGradientBorder
    self.degrees = degrees
    self.text = text
    self.image = image
  }
  
  var body: some View {
    LazyVGrid(columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible(), spacing: 15)], spacing: 15) {
      ForEach(data.indexed(), id: \.1.id) { index, social in
        Button {
          contains(social.id) ? deselect(social.id) : select(social.id)
        } label: {
          RoundedRectangle(cornerRadius: 20)
            .rotatingGradientBorder(
              showBorder: showGradientBorder(social.id),
              degrees: degrees
            )
            .aspectRatio(1.25, contentMode: .fit)
            .backport.overlay(alignment: .center) {
              VStack {
                //image(social)
                EmptyView()
                  .padding(.bottom, 15)
                text(social)
                  .bold()
              }
            }
        }
        .padding(.leading, index.isMultiple(of: 2) ? 15 : 0)
        .padding(.trailing, !index.isMultiple(of: 2) ? 15 : 0)
      }
    }
  }
}
