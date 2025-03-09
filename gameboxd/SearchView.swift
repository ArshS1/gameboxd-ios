//
//  SearchView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

@available(iOS 17, *)
struct SearchView: View {
    @State private var searchResults: [Game] = []
    @State private var selectedGame: Game?
    @State private var isLoading = false
    @State private var isPresented = false
    var searchText: String
    @Environment(\.presentationMode) var presentationMode
    
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
                        NavigationLink(destination: GameDetailView(gameId: game.id, isPresented: $isPresented)
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarItems(leading: BackButton())) {
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
                        }
                    }
                }
            }
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to Main Page")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            fetchSearchResults()
        }
        .navigationTitle("Search Results")
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

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back to Search Results")
            }
        }
    }
}

@available(iOS 17, *)
struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: "Fifa")
    }
}
