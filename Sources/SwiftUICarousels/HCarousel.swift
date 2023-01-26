import SwiftUI
import Combine

public struct HCarousel<Item: View>: View {
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

    public init(
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

    public var body: some View {
        ZStack {
            GeometryReader { geo in
                HStack(spacing: spacing) {
                    ForEach(0..<itemCount, id: \.self) { index in
                        switch index {
                        case 0:
                            items(index)
                                .frame(width: geo.size.width - (sideVisibility * 2))
                                .scaleEffect(CGSize(width: transforms[index], height: transforms[index]))
                                .padding(.leading, sideVisibility)
                        case itemCount - 1:
                            items(index)
                                .frame(width: geo.size.width - (sideVisibility * 2))
                                .scaleEffect(CGSize(width: transforms[index], height: transforms[index]))
                                .padding(.trailing, sideVisibility)
                        default:
                            items(index)
                                .frame(width: geo.size.width - (sideVisibility * 2))
                                .scaleEffect(CGSize(width: transforms[index], height: transforms[index]))
                        }
                    }
                }
                .offset(CGSize(width: offset, height: 0))
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        calculateOffset(dragValue: value)
                    }
                    .onEnded({ value in
                        didUpdatePage = false
                        snap(animated: true)
                        lastTranslation = value.translation.width
                    })
                )
                .onChange(of: page, perform: { _ in
                    setCardTransforms(animated: true)
                })
                .onAppear {
                    cardSize = geo.size.width - (sideVisibility * 2)
                    setupPageRanges()
                    setCardTransforms(animated: false)
                    snap(animated: false)
                }
            }
        }
    }

    // MARK: - Card Transforms -

    private func setCardTransforms(animated: Bool) {
        withAnimation(animated ? Animation.spring() : Animation.linear(duration: 0)) {
            var newTransforms = [CGFloat](repeating: 0.8, count: itemCount)
            newTransforms[page] = 1.0
            transforms = newTransforms
        }
    }

    // MARK: - Drag Handling -

    private func calculateOffset(dragValue: DragGesture.Value) {
        if dragValue.translation.width != 0 {
            let dragDistance = dragValue.translation.width - lastTranslation
            var newOffset = offset + dragDistance

            // Get whole content size with spacings
            let contentSize = (cardSize * CGFloat(itemCount)) +
            (sideVisibility * 2) +
            (spacing * CGFloat(itemCount - 1))

            let maxOffset = contentSize - cardSize - (sideVisibility * 2)

            if newOffset < 0 && newOffset > -maxOffset {
                newOffset = offset + dragDistance
            } else if newOffset <= -maxOffset {
                newOffset = -maxOffset
            } else {
                newOffset = 0
            }

            withAnimation(Animation.linear(duration: 0.1)) {
                offset = newOffset
            }

            calculatePage(dragDistance: dragDistance)
        }

        lastTranslation = dragValue.translation.width
    }

    // MARK: - Paging -

    private func setupPageRanges() {
        guard pageRanges.isEmpty else { return }

        var ranges = [0..<(Int(sideVisibility + cardSize / 2))]
        let normalPageSize = Int(cardSize + spacing)

        for _ in 1..<itemCount {
            ranges.append(ranges.last!.upperBound..<(ranges.last!.upperBound + normalPageSize))
        }

        pageRanges = ranges
    }

    private func snap(animated: Bool) {
        withAnimation(animated ? Animation.spring() : Animation.linear(duration: 0)) {
            if page > 0 {
                offset = (-cardSize - spacing) * Double(page)
            } else {
                offset = 0
            }
        }
    }

    private func calculatePage(dragDistance: CGFloat) {
        var calculatedPage = 0

        guard itemCount > 1 else {
            page = calculatedPage
            return
        }

        for index in 0..<itemCount {
            if pageRanges[index].contains(-Int(offset)) {
                calculatedPage = index
            }
        }

        if page == calculatedPage {
            if dragDistance > 30.0 {
                calculatedPage = max(0, calculatedPage - 1)
            } else if dragDistance < -30.0  {
                calculatedPage = min(itemCount - 1, calculatedPage + 1)
            }
        }

        if page != calculatedPage && !didUpdatePage {
            page = calculatedPage
            didUpdatePage = true
        }
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        HCarousel(numberOfItems: 3, items: { index in
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(.blue.gradient)
                Text("\(index)")
                    .foregroundColor(.white)
            }
        })
        .frame(height: 450)
    }
}
