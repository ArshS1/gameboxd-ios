//
//  Welcome.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct WelcomeView: View {
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
                    
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
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
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
