//
//  ContentView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

@available(iOS 17, *)
struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var upcomingGames: [Game] = []
    @State private var popularGames: [Game] = []
    @State private var newGames: [Game] = []
    @State private var topRatedGames: [Game] = []
    @State private var shooterGames: [Game] = []
    @State private var isSearchActive = false
    @State private var selectedGame: Game?
    @State private var showDetailView = false
    
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    ScrollView {
                        VStack {
                            // Search Bar
                            HStack {
                                TextField("Search...", text: $searchText, onCommit: {
                                    isSearchActive = true
                                })
                                .padding()
                                .background(isDarkMode ? Color(.systemGray4) : Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .foregroundColor(isDarkMode ? .white : .black)

                                NavigationLink(destination: SearchView(searchText: searchText).navigationBarBackButtonHidden(true), isActive: $isSearchActive) {
                                    EmptyView()
                                }
                            }
                            
                            // Top Rated Games
                            sectionView(title: "Top Rated Games", games: topRatedGames)
                            
                            // Upcoming Games Section
                            sectionView(title: "Upcoming Games", games: upcomingGames)

                            // Popular Games Section
                            sectionView(title: "Popular Games", games: popularGames)

                            // New Games Section
                            sectionView(title: "New Games", games: newGames)
                            
                            // Shooter Games Section
                            sectionView(title: "Shooter Games", games: shooterGames)

                            Spacer()
                        }
                        .onAppear {
                            fetchUpcomingGames()
                            fetchPopularGames()
                            fetchNewGames()
                            fetchShooterGames()
                            fetchTopRatedGames()
                        }
                    }
                } else if selectedTab == 1 {
                    FavoriteView()
                } else if selectedTab == 2 {
                    UserView()
                }
                
                // Tab Bar
                HStack {
                    tabBarItem(icon: "list.bullet", text: "Feed", tabIndex: 0)
                    tabBarItem(icon: "star.fill", text: "Games", tabIndex: 1)
                    tabBarItem(icon: "person.circle", text: "Profile", tabIndex: 2)
                }
                .background(isDarkMode ? Color(.black) : Color(.systemGray6))
                .padding(.bottom, 10)
            }
            .background(isDarkMode ? Color(.black) : Color(.systemGray5))
            .edgesIgnoringSafeArea(.bottom)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showDetailView) {
                if let game = selectedGame {
                    GameDetailView(gameId: game.id, isPresented: $showDetailView)
                }
            }
        }
    }

    // MARK: - Helper Views

    private func sectionView(title: String, games: [Game]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
                .foregroundColor(isDarkMode ? .white : .black)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(games) { game in
                        VStack {
                            AsyncImage(url: URL(string: game.cover ?? "https://gameboxd-kappa.vercel.app/images/no_cover.png")) { image in
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
                                .foregroundColor(isDarkMode ? .white : .black)
                            Text(game.release_date ?? "Release date not available")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 100)
                        .onTapGesture {
                            selectedGame = game
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showDetailView = true
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 200)
        }
        .background(isDarkMode ? Color(.systemGray4) : Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }

    private func tabBarItem(icon: String, text: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            VStack {
                Image(systemName: icon)
                Text(text)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .foregroundColor(selectedTab == tabIndex ? .blue : .gray)
    }

    // MARK: - API Calls
    func fetchTopRatedGames() {
        guard let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/games?filters=Any Time,Any Genre,Any Platform,Any ESRB,Top Rated Games") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.topRatedGames = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
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
    
    func fetchShooterGames() {
        guard let url = URL(string: "https://arshhhyyy.pythonanywhere.com/games/games?filters=Any Time,Shooter,Any Platform,Any ESRB,Any Sort") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let games = try JSONDecoder().decode([Game].self, from: data)
                    DispatchQueue.main.async {
                        self.shooterGames = games
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

@available(iOS 17, *)
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
