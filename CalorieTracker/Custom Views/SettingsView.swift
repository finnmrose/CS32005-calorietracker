//
//  SettingsView.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    @Environment(Log.self) private var log
    @Environment(\.dismiss) private var dismiss
    let date: Date
    @State private var s: Food.Nutrient = .none
    @State var initial_goals: [Food.Nutrient: Float] = [:]
    
    var body: some View {
        @Bindable var log = log
        
        var remaining_nutrients: [Food.Nutrient] {
            Food.Nutrient.allCases.filter({ x in
                return !log.default_goals.keys.contains(x)})
        }
        
        Form {
            Section (header: Text("Daily Goals")) {
                ForEach(log.default_goals.keys.sorted(by: {$0.rawValue < $1.rawValue})) { key in
                    FloatField(label: key.long_name, value: $log.default_goals[key], required: false)
                }.onDelete(perform: delete)
                
                if !remaining_nutrients.isEmpty {
                    Picker(selection: $s) {
                        Text("").tag(Food.Nutrient.none)
                        ForEach(remaining_nutrients) { nutrient in
                            Text(nutrient.long_name).tag(nutrient)
                        }
                    } label: {
                        Label("New Goal", systemImage: "plus")
                            .foregroundStyle(.link)
                    }
                    .onChange(of: s) {
                        if s != .none {
                            log.default_goals[s] = 0
                            s = .none
                        }
                    }
                }
            }
            
            
        }.toolbar {
            ToolbarItem (placement: .confirmationAction) {
                Button("Save", role: .confirm) {
                    log[date].goals = log.default_goals
                    log.commit()
                    dismiss()
                }.disabled(log.default_goals == initial_goals)
            }
            ToolbarItem (placement: .cancellationAction) {
                Button("Cancel", systemImage: "chevron.left", role: .cancel) {
                    log.default_goals = initial_goals
                    log.commit()
                    dismiss()
                }
            }
        }.navigationBarBackButtonHidden()
            .onAppear {
                for key in log.default_goals.keys {
                    initial_goals[key] = Float(log.default_goals[key]!)
                }
            }
    }
    
    func delete(at offsets: IndexSet) {
        if let ndx = offsets.first {
            let item = log.default_goals.keys.sorted(by: {$0.rawValue < $1.rawValue})[ndx]
            log.default_goals.removeValue(forKey: item)
            log.commit()
        }
    }
    
    
    
    func move(_ difference: ReorderDifference<UUID, ReorderableSingleCollectionIdentifier>) {
        print(difference.sources, difference.destination.position)
    }
}

#Preview {
    NavigationStack {
        SettingsView(date: .now)
            .sampleDataContainer()
    }
}
