//
//  GameDetailView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct GameDetailView: View {
    var game: Game
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.cover)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .padding()
            
            Text(game.name)
                .font(.largeTitle)
                .padding()
            
            Text("Release Date: \(game.release_date)")
                .font(.title2)
                .padding()
            
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
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
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
    }
}

struct GameDetailView_Preview: PreviewProvider {
    static var previews: some View {
        GameDetailView(game: Game(id: 1, name: "Example Game", cover: "https://example.com/cover.jpg", release_date: "Feb 27"), isPresented: .constant(true))
    }
}
