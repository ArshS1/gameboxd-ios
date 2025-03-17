//
//  gameboxdApp.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/15/25.
//

import SwiftUI
import SwiftData

@available(iOS 17, *)
@main
struct gameboxdApp: App {
    // Declare the modelContainer as an optional to handle errors during initialization
    private var modelContainer: ModelContainer?

    init() {
        do {
            // Try initializing the model container
            modelContainer = try ModelContainer(for: FavoriteGame.self, SavedGame.self)
        } catch {
            // Handle any errors here, for example, printing the error
            print("Failed to initialize model container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            if let modelContainer = modelContainer {
                // Pass the modelContext from the modelContainer to the environment
                WelcomeView()
                    .environment(\.modelContext, modelContainer.mainContext)
            } else {
                // Fallback view if the model container failed to initialize
                Text("Failed to load data")
                    .padding()
            }
        }
    }
}
