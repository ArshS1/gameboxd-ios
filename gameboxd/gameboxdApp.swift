//
//  gameboxdApp.swift
//  gameboxd
//
//  Created by Arshdeep Singh on 2/15/25.
//

import SwiftUI

@available(iOS 17, *)
@main
struct gameboxdApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .modelContainer(for: FavoriteGame.self)
        }
    }
}
