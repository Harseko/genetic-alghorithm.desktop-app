//
//  genetic_alghorithm_desktop_appApp.swift
//  genetic-alghorithm.desktop-app
//
//  Created by Никита Харсеко on 13/10/2024.
//

import SwiftUI
import SwiftData

@main
struct genetic_alghorithm_desktop_appApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
