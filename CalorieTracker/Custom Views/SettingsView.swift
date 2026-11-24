//
//  SettingsView.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//

import SwiftUI
import Foundation
import SwiftData

struct SettingsView: View {
    @Environment(Log.self) private var log
    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer
    
    let date: Date
    @State private var selection: Food.Nutrient = .none
    @State private var initial_goals: [Food.Nutrient: Float] = [:]
    @State private var initial_meals: [Meal] = []
    
    @State private var confirm_reset: Bool = false
    @State private var confirm_change: Bool = false
    @State private var confirm_delete: Bool = false
    
    var body: some View {
        @Bindable var log = log
        
        var remaining_nutrients: [Food.Nutrient] {
            Food.Nutrient.allCases.filter({ x in
                return !log.default_goals.keys.contains(x)})
        }
        
        Form {
            Section (header: Text("Default Goals")) {
                ForEach(log.default_goals.keys.sorted(by: {$0.rawValue < $1.rawValue})) { key in
                    FloatField(label: key.long_name, value: $log.default_goals[key], required: false)
                }.onDelete(perform: delete_goal)
                
                if !remaining_nutrients.isEmpty {
                    Picker(selection: $selection) {
                        Text("").tag(Food.Nutrient.none)
                        ForEach(remaining_nutrients) { nutrient in
                            Text(nutrient.long_name).tag(nutrient)
                        }
                    } label: {
                        Label("New Goal", systemImage: "plus")
                            .foregroundStyle(.link)
                    }
                    .onChange(of: selection) {
                        if selection != .none {
                            log.default_goals[selection] = 0
                            selection = .none
                        }
                    }
                }
            }
            
            Section(header: Text("Default Meals")) {
                ForEach($log.default_meals.sorted(by: {$0.sortIndex.wrappedValue < $1.sortIndex.wrappedValue})) { $meal in
                    TextField(meal.label, text: $meal.label)
                }.onDelete(perform: delete_meal)
            }
            
            Section(header: Text("Delete Data")) {
                
                Button("Delete current day data", role: .destructive) {
                    confirm_delete = true
                }
                .alert("This will delete all data for \(date.formatted(date: .abbreviated, time: .omitted)). Are you sure?", isPresented: $confirm_delete) {
                    Button("Cancel", role: .cancel) {
                        confirm_delete = false
                    }
                    
                    Button("Delete", role: .destructive) {
                        log.data.removeValue(forKey: date)
                        log.commit()
                        dismiss()
                    }
                }
                
                Button("Reset all data", role: .destructive) {
                    confirm_reset = true
                }
                .foregroundStyle(.red)
                .alert("This will delete all stored data. Are you sure?", isPresented: $confirm_reset) {
                    Button("Cancel", role: .cancel) {
                        confirm_reset = false
                    }
                    
                    Button("Delete", role: .destructive) {
                        dataContainer.reset()
                        confirm_reset = false
                        dismiss()
                    }
                }
            }
            
        }.toolbar {
            ToolbarItem (placement: .confirmationAction) {
                Button("Save", role: .confirm) {
                    if log[date].isEmpty {
                        if log.default_goals != initial_goals {
                            log[date].goals = log.default_goals
                            log.commit()
                            dismiss()
                        }
                        if log.default_meals != initial_meals {
                            log[date].data = log.default_meals
                            log.commit()
                            dismiss()
                        }
                    } else {
                        confirm_change = true
                    }
                }
                .disabled(log.default_goals == initial_goals && log.default_meals == initial_meals)
                .alert("Current day \(date.formatted(date: .abbreviated, time: .omitted)) contains data. Changes will only affect future days.", isPresented: $confirm_change) {
                    Button("Cancel", role: .cancel) {
                        confirm_change = false
                    }
                    Button("OK", role: .confirm) {
                        log.commit()
                        dismiss()
                    }
                }
            }
            ToolbarItem (placement: .cancellationAction) {
                Button("Cancel", systemImage: "chevron.left", role: .cancel) {
                    log.default_goals = initial_goals
                    log.commit()
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            for key in log.default_goals.keys {
                initial_goals[key] = Float(log.default_goals[key]!)
            }
            
            initial_meals = log.default_meals.copy()
        }
    }
    
    func delete_goal(at offsets: IndexSet) {
        if let ndx = offsets.first {
            let item = log.default_goals.keys.sorted(by: {$0.rawValue < $1.rawValue})[ndx]
            log.default_goals.removeValue(forKey: item)
            log.commit()
        }
    }
    
    func delete_meal(at offsets: IndexSet) {
        var l = log.default_meals.sorted(by: {$0.sortIndex < $1.sortIndex})
        l.remove(atOffsets: offsets)
        log.default_meals = l
        log.commit()
    }
}

#Preview {
    NavigationStack {
        SettingsView(date: .now)
            .sampleDataContainer()
    }
}
