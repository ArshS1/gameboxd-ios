//
//  FavoriteView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct FavoriteView: View {
    @State private var favoriteGames: [Game] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Favorite Games")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                if favoriteGames.isEmpty {
                    Text("No favorite games yet.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List(favoriteGames) { game in
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
                                if let genres = game.genres, !genres.isEmpty {
                                    Text("Genres: \(genres.joined(separator: ", "))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                fetchFavoriteGames()
            }
            .navigationBarTitle("Favorites", displayMode: .inline)
        }
    }

    func fetchFavoriteGames() {
        favoriteGames = [
            // Add your favorite games here
        ]
    }
}


struct FavoriteView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
