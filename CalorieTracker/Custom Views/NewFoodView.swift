//
//  NewFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct NewFoodView : View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name: String = ""
    @State private var nutritional_info: [Food.Nutrient: Float] = [:]
    
    @State private var ingredients: [Food: Float] = [:]
    @State private var showSheet: Bool = false
    
    @State private var p_type: Portion = .none
    @State private var p_size: Float? = nil
    
    var body : some View {
        Form {
            HStack {
                Text("Name")
                TextField("Required", text: $name)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
                
            }
            Picker("Portion Type", selection: $p_type.animation()) {
                ForEach(Portion.allCases) { portion in
                    Text(portion.description)
                }
            }.disabled(!ingredients.isEmpty)
            
            if !name.isEmpty, !p_type.isNone {
                Section(header: Text("Nutritional Information per \(p_type.alt_unit)")) {
                    ForEach(Food.Nutrient.allCases) { nutrient in
                        FloatField(label: nutrient.long_name, value: $nutritional_info[nutrient], required: nutrient.required)
                    }
                }
            }
            Section(header: Text("Ingredients")) {
                Button("Add Ingredient", systemImage: "plus") {
                    showSheet.toggle()
                }.foregroundStyle(.link)
                
                List {
                    ForEach(Array(ingredients.keys)) { food in
                        HStack {
                            Text(FoodInstance.format_amount(food, amount: ingredients[food]!))
                            Text(food.name)
                        }
                    }.onDelete(perform: delete)
                }
                
            }.navigationLinkIndicatorVisibility(.hidden)
        }
        .navigationTitle(Text("Create new food"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    context.insert(Food(name: name, portion_type: p_type, nutritional_info: nutritional_info.mapValues({$0 / p_type.input_scale})))
                    try? context.save()
                    dismiss()
                }.disabled(name.isEmpty || p_type.isNone || required_values_not_filled())
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: update_ingredients) {
            NavigationStack {
                SearchFoodView(ingredients: $ingredients)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    func required_values_not_filled() -> Bool {
        for nutrient in Food.Nutrient.allCases {
            if nutrient.required && !nutritional_info.keys.contains(nutrient) {
                return true
            }
        }
        return false
    }
    
    func update_ingredients() {
        if !ingredients.isEmpty {
            p_type = .count
            name = name.isEmpty ? "New Food" : name
        }
        
        nutritional_info = [:]
        
        for i in ingredients.keys {
            for n in i.nutritional_info.keys {
                nutritional_info[n, default: 0] += (i[n] ?? 0) * ingredients[i]!
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let ndx = offsets.first {
            let item = ingredients.keys.sorted(by: {$0.timestamp > $1.timestamp})[ndx]
            ingredients.removeValue(forKey: item)
            update_ingredients()
        }
    }
}

struct FloatField : View {
    let label: String
    @Binding var value: Float?
    let required: Bool
    
    var body : some View {
        HStack {
            Text(label)
            TextField(required ? "Required" : "0", value: $value, format: .number.precision(.fractionLength(0...2)))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
}

#Preview {
    NavigationStack {
        NewFoodView()
            .sampleDataContainer()
    }
}
