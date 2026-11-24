//
//  ContentView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        DayView(.now)
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
