import SwiftUI

struct VCarousel<Item: View>: View {
    private let sideVisibility: CGFloat
    private let spacing: CGFloat
    private let itemCount: Int
    private let items: (_ index: Int) -> Item

    @State private var offset: CGFloat = 0.0
    @State private var lastTranslation = 0.0
    @State private var cardSize = 0.0
    @State private var page: Int
    @State private var pageRanges = [Range<Int>]()
    @State private var transforms: [CGFloat]
    @State private var didUpdatePage = false

    init(
        numberOfItems: Int,
        sideVisibility: CGFloat = 64,
        itemSpacing: CGFloat = 8,
        startItemIndex: Int = 0,
        @ViewBuilder items: @escaping (_ index: Int) -> Item)
    {
        self.itemCount = numberOfItems
        self.sideVisibility = sideVisibility
        self.spacing = itemSpacing
        self.items = items
        self.page = startItemIndex
        self.transforms = [CGFloat](repeating: 0.8, count: numberOfItems)
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct VCarousel_Previews: PreviewProvider {
    static var previews: some View {
        VCarousel(numberOfItems: 3) { index in
            Text("\(index)")
        }
    }
}
