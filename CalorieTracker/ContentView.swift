//
//  ContentView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(Log.self) private var log
    
    var body: some View {
        DayView(log[.now])
    }
}

#Preview {
    ContentView()
        .sampleDataContainer()
    
}

#Preview("No data") {
    ContentView()
        .emptyDataContainer()
}
