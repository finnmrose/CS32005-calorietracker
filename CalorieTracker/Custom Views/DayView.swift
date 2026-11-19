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
    
    init(_ day: Day) {
        self.day = day
    }
    
    var body : some View {
        NavigationStack {
            List {
                Section {
                    DayHeaderView($day)
                }
                
                ForEach(day.meals) { meal in
                    MealView(meal, day.date)
                }
            }
        }
    }
}

#Preview {
    DayView(Log.sampleData[.now])
        .environment(Log.sampleData)
}

