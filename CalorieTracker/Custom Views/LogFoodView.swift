//
//  LogFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI

struct LogFoodView : View {
    
    let food: Food
    
    @State private var weight: Float? = nil
    @State private var date: Date
    @State private var meal: String?
    
    @Environment(Log.self) private var log: Log
    @Environment(\.dismiss) private var dismiss
    
    @Binding var path: NavigationPath
    
    init(_ food: Food, date: Date = Date(), meal: String? = nil, path: Binding<NavigationPath>) {
        self.food = food
        self.date = date
        self.meal = meal
        self._path = path
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
                    dismiss()
                }.disabled(weight == nil || meal == nil)
            }
        }
    }
}
