import SwiftUI
import SwiftUICarousel

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue]

    var body: some View {
        VStack {
            HCarousel(numberOfItems: 3) { index in
                ZStack {
                    colors[index]
                    Text("\(index)")
                        .foregroundColor(.white)
                }
                .cornerRadius(8)
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
