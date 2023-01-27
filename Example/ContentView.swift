import SwiftUI
import SwiftUICarousel

struct ContentView: View {
    let movies = [
        Movie(name: "Dune", imageName: "dune"),
        Movie(name: "Avengers - Endgame", imageName: "endgame"),
        Movie(name: "Batman", imageName: "batman")
    ]

    @State private var page = 1

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(movies[page].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 30, opaque: true)
                    .ignoresSafeArea()
                    .animation(.linear(duration: 0.3), value: page)
                VStack {
                    Text(movies[page].name)
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .semibold,design: .rounded))

                    HCarousel(numberOfItems: 3, page: $page) { index in
                        CardView(movie: movies[index])
                    }
                    .frame(width: geo.size.width, height: 400)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
