import SwiftUI
import GoogleSignIn
import SwiftData

@available(iOS 17, *)
struct UserView: View {
    @Environment(\.modelContext) private var modelContext // Inject modelContext

    @State private var userName: String = ""
    @State private var userProfileImageURL: URL?
    @AppStorage("isSignedIn") private var isSignedIn = true
    @State private var showAlert = false
    @State private var showResetAlert = false 
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
            Spacer()
            Button(action: {
                showResetAlert = true
            }) {
                Text("Reset User Data")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 10)
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Reset User Data"),
                    message: Text("This will delete all your saved data. Are you sure?"),
                    primaryButton: .destructive(Text("Reset")) {
                        resetUserData()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            loadUserData()
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

        func resetUserData() {
        do {
            let favoriteGames = try modelContext.fetch(FetchDescriptor<FavoriteGame>())
            let savedGames = try modelContext.fetch(FetchDescriptor<SavedGame>())

            favoriteGames.forEach { modelContext.delete($0) }
            savedGames.forEach { modelContext.delete($0) }

            try modelContext.save()

            print("User data reset successfully.")
        } catch {
            print("Error resetting user data: \(error.localizedDescription)")
        }
    }    

}

@available(iOS 17, *)
struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        UserView()
            .modelContainer(for: SavedGame.self)
    }
}
