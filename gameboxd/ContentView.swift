//
//  ContentView.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            if selectedTab == 0 {
                // Main Content
                VStack {
                    // Search Bar
                    TextField("Search...", text: $searchText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Upcoming Games Placeholder
                    VStack(alignment: .leading) {
                        Text("Upcoming Games")
                            .font(.headline)
                            .padding(.leading)
                        Text("Placeholder for upcoming games")
                            .padding()
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Trending Games Placeholder
                    VStack(alignment: .leading) {
                        Text("Trending Games")
                            .font(.headline)
                            .padding(.leading)
                        Text("Placeholder for trending games")
                            .padding()
                    }
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
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
        }
    }
}

