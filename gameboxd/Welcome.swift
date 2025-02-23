//
//  Welcome.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI
import GoogleSignIn

struct WelcomeView: View {
    @Environment(\.openURL) var openURL
    @State private var isSignedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.black) // Light gray background
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Welcome to")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .colorInvert()
                    
                    Image("logo") // Make sure this image is in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300) // Larger logo
                    
                    Spacer()
                    
                    if isSignedIn {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            Text("Go to Home Screen")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 40) // Pushes button to bottom
                    } else {
                        Button(action: {
                            handleSignUp()
                        }) {
                            Text("Let's Go")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 40) // Pushes button to bottom
                    }
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
    
    func handleSignUp() {
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                print("Sign in failed: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No result returned")
                return
            }
            
            isSignedIn = true
            print("User signed in: \(result.user.profile?.name ?? "No Name")")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}