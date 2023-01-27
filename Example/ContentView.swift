import SwiftUI
import SwiftUICarousel

struct ContentView: View {
    let movies = [
        Movie(name: "Dune", imageName: "dune"),
        Movie(name: "Endgame", imageName: "endgame"),
        Movie(name: "Batman", imageName: "batman")
    ]

    var body: some View {
        ZStack {
            HCarousel(numberOfItems: 3) { index in
                CardView(movie: movies[index])
            }
            .frame(height: 400)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
