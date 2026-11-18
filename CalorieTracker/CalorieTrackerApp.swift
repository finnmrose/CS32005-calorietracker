//
//  CalorieTrackerApp.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

@main
struct CalorieTrackerApp: App {
    let dataContainer = DataContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataContainer)
                .withLog(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
