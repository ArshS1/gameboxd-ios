//
//  UserView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/22/25.
//

import SwiftUI
import GoogleSignIn

struct UserView: View {
    @State private var userName: String = ""
    @State private var userProfileImageURL: URL?
    @AppStorage("isSignedIn") private var isSignedIn = true
    
    var body: some View {
        VStack {
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
                signOut()
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
            
            Spacer()
        }
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
        // Handle additional sign-out logic if needed
    }
}

struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}