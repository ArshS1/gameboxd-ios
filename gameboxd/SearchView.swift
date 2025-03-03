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
    @State private var isLoading = false
    var searchText: String
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
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
                            }
                        }
                        .onTapGesture {
                            selectedGame = game
                            showModal = true
                        }
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
                GameDetailView(gameId: game.id, isPresented: $showModal)
        }
    }
    }
    
    func fetchSearchResults() {
        guard let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/getgames?search=\(searchTextEncoded)") 
        else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let rawGames = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                    
                    let games = rawGames.compactMap { dict -> Game? in
                        var modifiedDict = dict
                        if modifiedDict["release_date"] == nil {
                            modifiedDict["release_date"] = "Release date not available" 
                        }
                        
                        if let jsonData = try? JSONSerialization.data(withJSONObject: modifiedDict),
                           let game = try? decoder.decode(Game.self, from: jsonData) {
                            return game
                        }
                        return nil
                    }
                    
                    DispatchQueue.main.async {
                        self.searchResults = games
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error processing data: \(error)")
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
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
