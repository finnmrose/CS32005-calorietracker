//
//  DayView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct DayView : View {
    
    @State var day: Day
    @State private var path = NavigationPath()
    
    init(_ day: Day) {
        self.day = day
    }
    
    var body : some View {
        NavigationStack (path: $path) {
            List {
                Section {
                    DayHeaderView($day)
                }
                
                ForEach(day.meals) { meal in
                    MealView(meal, day.date, path: $path)
                }
            }
        }.frame(height: .infinity)
    }
}

#Preview {
    DayView(Log.sampleData[.now])
        .environment(Log.sampleData)
}

