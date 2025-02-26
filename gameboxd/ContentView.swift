//
//  ContentView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct Game: Identifiable, Decodable {
    let id: Int
    let name: String
    let cover: String
    let release_date: String
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var upcomingGames: [Game] = []
    @State private var popularGames: [Game] = []
    @State private var newGames: [Game] = []
    @State private var isSearchActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    // Main Content
                    ScrollView {
                        VStack {
                            // Search Bar
                            HStack {
                                TextField("Search...", text: $searchText, onCommit: {
                                    isSearchActive = true
                                })
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                                NavigationLink(destination: SearchView(searchText: searchText), isActive: $isSearchActive) {
                                    EmptyView()
                                }
                            }
                            
                            // Upcoming Games
                            VStack(alignment: .leading) {
                                Text("Upcoming Games")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(upcomingGames) { game in
                                            VStack {
                                                AsyncImage(url: URL(string: game.cover)) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .cornerRadius(10)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Text(game.name)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                Text(game.release_date)
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 200)
                            }
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top)
                            
                            // Popular Games
                            VStack(alignment: .leading) {
                                Text("Popular Games")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(popularGames) { game in
                                            VStack {
                                                AsyncImage(url: URL(string: game.cover)) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .cornerRadius(10)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Text(game.name)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                Text(game.release_date)
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 200)
                            }
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top)
                            
                            // New Games
                            VStack(alignment: .leading) {
                                Text("New Games")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(newGames) { game in
                                            VStack {
                                                AsyncImage(url: URL(string: game.cover)) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 150)
                                                        .cornerRadius(10)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Text(game.name)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                                Text(game.release_date)
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 200)
                            }
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top)
                            
                            Spacer()
                        }
                        .onAppear {
                            fetchUpcomingGames()
                            fetchPopularGames()
                            fetchNewGames()
                        }
                    }
                } else {
                    // User Profile Section
                    UserView()
                }
                
                // Tab Bar
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Feed")
                        }
                    }
                    .padding()
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                    }
                    .padding()
                    .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    
                    Spacer()
                }
                .background(Color(.systemGray6))
                .padding(.bottom, 10)
            }
            .background(Color(.systemGray5))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func fetchUpcomingGames() {
        guard let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/upcoming") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.upcomingGames = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchPopularGames() {
        guard let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/popular") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.popularGames = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchNewGames() {
        guard let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/recent") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.newGames = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}