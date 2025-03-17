import SwiftUI
import GoogleSignIn
import SwiftData

@available(iOS 17, *)
struct UserView: View {
    @State private var userName: String = ""
    @State private var userProfileImageURL: URL?
    @AppStorage("isSignedIn") private var isSignedIn = true
    @State private var showAlert = false
    @Environment(\.modelContext) private var modelContext
    @Query private var savedGames: [SavedGame]

    @State private var showingGameDetails = false
    @State private var selectedGame: SavedGame?

    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isDarkMode.toggle()
                }) {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(isDarkMode ? .yellow : .blue)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            if let url = userProfileImageURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }

            Text(userName)
                .font(.largeTitle)
                .padding()

            Button(action: {
                showAlert = true
            }) {
                Text("Sign Out")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 20)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sign Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        signOut()
                    },
                    secondaryButton: .cancel()
                )
            }

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
            Spacer()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            loadUserData()
        }
        .onChange(of: savedGames) { _ in
            print("Saved Games updated: \(savedGames)")
        }
    }

    func loadUserData() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            userName = user.profile?.name ?? "No Name"
            userProfileImageURL = user.profile?.imageURL(withDimension: 100)
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
    }
}

@available(iOS 17, *)
struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        UserView()
            .modelContainer(for: SavedGame.self)
    }
}
