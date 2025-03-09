import SwiftUI
import SwiftData

@available(iOS 17, *)
struct GameDetailView: View {
    var gameId: Int
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteGames: [FavoriteGame]

    @State private var game: Game?
    @State private var isLoading = true
    @State private var urlString: String = ""
    @State private var isFavorite = false

    var body: some View {
        ZStack {
            VStack {
                if let game = game {
                    ScrollView {
                        VStack {
                            AsyncImage(url: URL(string: game.cover)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 300)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.top, 40)

                            Text(game.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()

                            Text("Release Date: \(game.release_date ?? "Not Available")")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)

                            if let summary = game.summary {
                                Text(summary)
                                    .font(.body)
                                    .padding()
                            }

                            if let genres = game.genres, !genres.isEmpty {
                                Text("Genres")
                                    .font(.headline)
                                    .padding(.top, 10)
                                
                                ForEach(genres, id: \.self) { genre in
                                    Text(genre)
                                        .font(.subheadline)
                                        .padding(.bottom, 2)
                                }
                            }

                            if !game.platforms.isEmpty {
                                Text("Platforms")
                                    .font(.headline)
                                    .padding(.top, 10)
                                ForEach(game.platforms, id: \.name) { platform in
                                    HStack {
                                        if let logoURL = platform.logo_url, let url = URL(string: logoURL) {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        Text(platform.name)
                                            .font(.subheadline)
                                    }
                                    .padding(.bottom, 2)
                                }
                            }

                            Button(action: {
                                toggleFavorite()
                            }) {
                                HStack {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(isFavorite ? .red : .gray)
                                    Text(isFavorite ? "Unfavorite" : "Favorite")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            fetchGameDetails()
            checkIfFavorite()
        }
    }

    // Fetch game details from API
    func fetchGameDetails() {
        let urlString = "https://arshhhyyy.pythonanywhere.com/games/getgame/\(gameId)"
        self.urlString = urlString

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    isLoading = false
                    return
                }

                if let data = data {
                    do {
                        let decodedDictionary = try JSONDecoder().decode([String: Game].self, from: data)
                        if let game = decodedDictionary.values.first {
                            self.game = game
                            checkIfFavorite() // Ensure favorite status is checked when game loads
                        } else {
                            print("Error: No game found")
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                } else {
                    print("No data received")
                }

                isLoading = false
            }
        }.resume()
    }

    // Check if game is already favorited
    func checkIfFavorite() {
        guard let game = game else { return }
        isFavorite = favoriteGames.contains { $0.id == game.id }
    }

    // Toggle favorite status
    func toggleFavorite() {
        guard let game = game else { return }

        if isFavorite {
            // Remove from favorites
            if let existingFavorite = favoriteGames.first(where: { $0.id == game.id }) {
                modelContext.delete(existingFavorite)
            }
        } else {
            // Save new favorite
            let newFavorite = FavoriteGame(
                id: game.id,
                name: game.name,
                cover: game.cover,
                release_date: game.release_date,
                summary: game.summary,
                genres: game.genres,
                platforms: game.platforms
            )
            modelContext.insert(newFavorite)
        }

        isFavorite.toggle()
    }
}

@available(iOS 17.0, *)
struct GameDetailView_Preview: PreviewProvider {
    static var previews: some View {
        GameDetailView(gameId: 1, isPresented: .constant(true))
            .modelContainer(for: FavoriteGame.self) // Ensures preview works
    }
}
