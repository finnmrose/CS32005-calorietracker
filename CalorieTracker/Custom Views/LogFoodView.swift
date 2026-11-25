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
    
    @State private var portion_size: Float? = nil
    @State private var date: Date
    @State private var meal: Meal
    @State private var update: Bool = false
    
    @Environment(\.modelContext) private var context
    @Environment(Log.self) private var log: Log
    @Environment(\.dismiss) private var dismiss
    
    init(_ food: Food, date: Date = Date(), meal: Meal) {
        self.food = food
        self.date = date
        self.meal = meal
    }
    
    var body : some View {
        Form {
            DatePicker("Date", selection: $date, displayedComponents: [.date])
                .onChange(of: date) {
                    if log[date].contains(meal) {
                        self.meal = log[date][meal]
                    } else {
                        self.meal = log[date].meals.first!
                    }
                    update.toggle()
                }
            Picker("Meal", selection: $meal) {
                ForEach(log[date].meals) { m in
                    Text(m.label).tag(m)
                }
            }.onChange(of: meal) {
                update.toggle()
            }
            HStack {
                Text(food.portion_type.isContinuous ? "Portion Size (\(food.portion_type.unit))" : "No. of Servings")
                Spacer()
                TextField("Required", value: $portion_size, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Section(header: Text("Nutritional Information")) {
                ForEach(Food.Nutrient.allCases) { item in
                    if food.nutritional_info[item] != nil {
                        HStack {
                            Text("\(item.long_name) \(item.alt_unit)")
                            Spacer()
                            Text("\(((food.nutritional_info[item] ?? 0) * (portion_size ?? 0)).formatted(.number.notation(.compactName)))")
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            
            if !food.ingredients.isEmpty {
                Section(header: Text("Ingredients")) {
                    ForEach(food.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                            Spacer()
                            Text((ingredient * (portion_size ?? 0)).amount_formatted)
                        }
                    }
                }
            }
        }
        .navigationTitle("Log \(food.name)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", systemImage: "checkmark") {
                    self.meal.foods.append(FoodInstance(food, amount: portion_size ?? 0))
                    food.timestamp = .now
                    log[date][meal] = meal
                    log.commit()
                    
                    dismiss()

                    
                }.disabled(portion_size == nil)
            }
        }
    }
}
