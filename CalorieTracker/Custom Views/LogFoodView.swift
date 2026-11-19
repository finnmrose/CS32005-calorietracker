//
//  LogFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct LogFoodView : View {
    
    let food: Food
    let dismissParent: DismissAction
    
    @State private var weight: Float? = nil
    @State private var date: Date
    @State private var meal: String?
    
    @Environment(\.modelContext) private var context
    @Environment(Log.self) private var log: Log
    @Environment(\.dismiss) private var dismiss
    
    init(_ food: Food, date: Date = Date(), meal: String? = nil, dismissParent: DismissAction) {
        self.food = food
        self.date = date
        self.meal = meal
        self.dismissParent = dismissParent
    }
    
    var body : some View {
        Form {
            DatePicker("Date", selection: $date, displayedComponents: [.date])
            Picker("Meal", selection: $meal) {
                ForEach(log[date].meals) { meal in
                    Text(meal.label).tag(meal.label)
                }
            }
            HStack {
                Text("Portion Weight")
                Spacer()
                TextField("Required", value: $weight, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Nutritional Information")) {
                ForEach(Food.Nutrient.allCases) { item in
                    if food.nutritional_info[item] != nil {
                        HStack {
                            Text(item.long_name)
                            Spacer()
                            Text("\(((food.nutritional_info[item] ?? 0) * (weight ?? 0) / 100).formatted(.number.notation(.compactName)))")
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
        }
        .navigationTitle("Log \(food.name)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark") {
                    
                    log[date][meal!]?.foods.append(FoodInstance(food, amount: weight ?? 0))
                    food.timestamp = .now
                    
                    try? context.save()
                    
                    dismiss()
                    dismissParent()
                    
                }.disabled(weight == nil || meal == nil)
            }
        }
    }
}
