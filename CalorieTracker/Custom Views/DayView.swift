//
//  DayView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct DayView : View {
    
    @Environment(Log.self) private var log: Log
    @State var day: Day
    @State private var refresh: Bool = false
    private let date: Date
    
    init(_ date: Date) {
        self.date = date
        self.day = Day(date)
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
                
                NavigationLink {
                    SettingsView(date: day.date)
                        .onDisappear {
                            day = log[date]
                            refresh.toggle()
                        }
                } label: {
                    Label("Settings", systemImage: "gearshape.fill")
                        .foregroundStyle(.link)
                }
                
            }
        }
        .onAppear {
            day = log[date]
        }
    }
}
