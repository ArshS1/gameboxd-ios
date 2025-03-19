//
//  GameDetailView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
struct GameDetailView: View {
    var gameId: Int
    @Binding var isPresented: Bool
    @Environment(\ .modelContext) private var modelContext
    @Query private var favoriteGames: [FavoriteGame]
    @Query private var savedGames: [SavedGame]

    @State private var game: Game?
    @State private var isLoading = true
    @State private var urlString: String = ""
    @State private var isFavorite = false
    @State private var showLogPopup = false
    @State private var rating: Int = 0
    @State private var feedback: String = ""
    @State private var gameName: String = ""

    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        ZStack {
            VStack {
                if let game = game {
                    ScrollView {
                        VStack(alignment: .center) {
                            AsyncImage(url: URL(string: game.cover)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 300)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                            .padding(.top, 10)
                            Divider().background(isDarkMode ? Color.white : Color.black)
                            Text(game.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()

                            Text("Release Date: \(game.release_date ?? "Not Available")")
                                                           .font(.title2)
                                                           .foregroundColor(.gray)
                                                           .padding(.bottom, 10)

                                                       if let summary = game.summary {
                                                           Text(summary)
                                                               .font(.body)
                                                               .padding()
                                                       }

                            HStack(alignment: .top, spacing: 20) {
                                if !game.platforms.isEmpty {
                                    VStack(alignment: .leading) {
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
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if let genres = game.genres, !genres.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Genres")
                                            .font(.headline)
                                            .padding(.top, 10)

                                        ForEach(genres, id: \.self) { genre in
                                            Text(genre)
                                                .font(.subheadline)
                                                .padding(.bottom, 2)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()

                            Divider().background(isDarkMode ? Color.white : Color.black)
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    toggleFavorite()
                                }) {
                                    HStack {
                                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(isFavorite ? .red : .gray)
                                        Text(isFavorite ? "Unfavorite" : "Favorite")
                                            .foregroundColor(isDarkMode ? .white : .black)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }

                                Button(action: {
                                    showLogPopup = true
                                }) {
                                    HStack {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                        Text("Log")
                                            .foregroundColor(isDarkMode ? .white : .black)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
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
        .sheet(isPresented: $showLogPopup) {
            VStack {
                if let game = game {
                    AsyncImage(url: URL(string: game.cover)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 200)
                            .cornerRadius(10)
                            .padding()
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text("Rate this Game")
                    .font(.headline)
                    .padding()

                HStack {
                    ForEach(1..<6) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(star <= rating ? .yellow : .gray)
                            .onTapGesture {
                                rating = star
                            }
                    }
                }
                .padding()

                TextField("Write your feedback...", text: $feedback)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Save") {
                    saveGameLog()
                    showLogPopup = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func saveGameLog() {
        guard let game = game else { return }
        let newSavedGame = SavedGame(name: gameName, cover: game.cover, rating: rating, feedback: feedback)
        modelContext.insert(newSavedGame)
        
        // Print a confirmation message
        print("Game Logged: \(gameName), Rating: \(rating), Feedback: \(feedback)")
    }

    
    // Fetch game details from API
    func fetchGameDetails() {
        let urlString = "https://arshhhyyy.pythonanywhere.com/games/getgame/\(gameId)"

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
                            self.gameName = game.name
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
