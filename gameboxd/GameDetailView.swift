//
//  GameDetailView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct GameDetailView: View {
    var gameId: Int
    @Binding var isPresented: Bool
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
                } else {
                    
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
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("🔹 Raw JSON Response: \(jsonString)")
                        }

                        let decodedDictionary = try JSONDecoder().decode([String: Game].self, from: data)
                        
                        if let game = decodedDictionary.values.first {
                            self.game = game
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

    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
    }

    func saveFavoriteStatus() {
    }

    func checkIfFavorite() {
    }
}

struct GameDetailView_Preview: PreviewProvider {
    static var previews: some View {
        GameDetailView(gameId: 1, isPresented: .constant(true))
    }
}
