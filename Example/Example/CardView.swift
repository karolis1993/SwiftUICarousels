import SwiftUI

struct CardView: View {
    let movie: Movie

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(movie.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(movie: Movie(name: "Batman", imageName: "dune"))
            .frame(height: 400)
            .padding()
    }
}
