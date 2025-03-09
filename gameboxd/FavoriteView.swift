import SwiftUI
import SwiftData

@available(iOS 17, *)
struct FavoriteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteGames: [FavoriteGame]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Favorite Games")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color(.systemGray6))

                    if favoriteGames.isEmpty {
                        Text("No favorite games yet.")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color(.systemGray6))
                        Spacer()
                    } else {
                        List {
                            ForEach(favoriteGames) { game in
                                HStack {
                                    AsyncImage(url: URL(string: game.cover)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 75)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    VStack(alignment: .leading) {
                                        Text(game.name)
                                            .font(.headline)
                                        Text(game.release_date ?? "Release date not available")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .onDelete(perform: deleteFavorite)
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle("Favorites", displayMode: .inline)
                .toolbar {
                    EditButton()
                }
            }
        }
    }

    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let gameToDelete = favoriteGames[index]
            modelContext.delete(gameToDelete)
        }
    }
}
