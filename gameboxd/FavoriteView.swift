import SwiftUI
import SwiftData

@available(iOS 17, *)
struct FavoriteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteGames: [FavoriteGame]
    @Query private var savedGames: [SavedGame]

    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Favorite Games")
                    .font(.title2)
                    .padding(.top, 20)

                if favoriteGames.isEmpty {
                    Text("No favorite games yet.")
                        .font(.title2)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(favoriteGames) { game in
                            NavigationLink(destination: GameDetailView(gameId: game.gameId ?? 0, isPresented: .constant(true))) {
                                GameRow(game: game)
                            }
                        }
                        .onDelete(perform: deleteFavorite)
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()

                Text("Personal Games")
                    .font(.title2)
                    .padding(.top, 5)

                if savedGames.isEmpty {
                    Text("No saved games found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(savedGames) { game in
                            NavigationLink(destination: GameDetailView(gameId: game.gameId ?? 0, isPresented: .constant(true))) {
                                SavedGameRow(game: game)
                            }
                        }
                        .onDelete(perform: deleteSaved)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .padding(.horizontal)
            .navigationTitle("Games")
            .toolbar {
                EditButton()
            }
        }
    }

    func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let gameToDelete = favoriteGames[index]
            modelContext.delete(gameToDelete)
        }
    }

    func deleteSaved(at offsets: IndexSet) {
        for index in offsets {
            let gameToDelete = savedGames[index]
            modelContext.delete(gameToDelete)
        }
    }
}

@available(iOS 17, *)
struct GameRow: View {
    let game: FavoriteGame

    var body: some View {
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
}

@available(iOS 17, *)
struct SavedGameRow: View {
    let game: SavedGame

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.cover)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 75)
            }

            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)

                Text(game.feedback ?? "No feedback available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)

            Spacer()

            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < game.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 5)
    }
}
