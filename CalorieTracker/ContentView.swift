//
//  ContentView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(Log.self) private var log: Log
    
    var body: some View {
        DayView(log[.now])
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
        .environment(Log.sampleData)
}

#Preview("No Data") {
    ContentView()
        .modelContainer(for: Food.self, inMemory: true)
        .environment(Log())
}
