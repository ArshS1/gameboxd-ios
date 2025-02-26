//
//  SearchView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI


struct SearchView: View {
    @State private var searchResults: [Game] = []
    @State private var selectedGame: Game?
    @State private var showModal = false
    @State private var fullURL: String = ""
    var searchText: String
    
    var body: some View {
        VStack {
            Text("Full URL: \(fullURL)")
                .font(.caption)
                .padding()
            
            if searchResults.isEmpty {
                Text("No results found for \"\(searchText)\"")
                    .padding()
            } else {
                List(searchResults) { game in
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
                            if let releaseDate: Optional = game.release_date {
                                Text(releaseDate!)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Release date not available")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onTapGesture {
                        selectedGame = game
                        showModal = true
                    }
                }
            }
        }
        .onAppear {
            fetchSearchResults()
        }
        .navigationTitle("Search Results")
        .sheet(isPresented: $showModal) {
            if let game = selectedGame {
                GameDetailView(game: game, isPresented: $showModal)
            }
        }
    }
    
    func fetchSearchResults() {
        guard let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/getgames?search=\(searchTextEncoded)") 
        else { return }
        
        fullURL = url.absoluteString
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: "Fifa")
    }
}
