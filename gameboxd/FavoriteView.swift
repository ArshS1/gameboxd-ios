import SwiftUI
import SwiftData

@available(iOS 17, *)
struct FavoriteView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteGames: [FavoriteGame]
    @Query private var savedGames: [SavedGame]

    @AppStorage("isDarkMode") private var isDarkMode = false

    @State private var showingGameDetails = false
    @State private var selectedGame: SavedGame?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)

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

            Text("Saved Games")
                .font(.title2)
                .padding(.top, 20)

            if savedGames.isEmpty {
                Text("No saved games found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(savedGames) { game in
                        HStack {
                            AsyncImage(url: URL(string: game.cover)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 75)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white, lineWidth: 2))
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 75)
                            }

                            VStack(alignment: .leading) {
                                Text(game.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)

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
            }
                }
                .navigationBarTitle("Games", displayMode: .inline)
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
