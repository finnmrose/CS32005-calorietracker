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
    
    init() {
        for n in Food.Nutrient.allCases {
            self.nutritional_info[n] = nil
        }
    }
    
    var body : some View {
        Form {
            
            HStack {
                Text("Name")
                TextField("Required", text: $name)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
            }
            
            Section(header: Text("Nutritional Information per 100g")) {
                ForEach(Food.Nutrient.allCases) { nutrient in
                    FloatField(label: nutrient.long_name, value: $nutritional_info[nutrient], required: nutrient.required)
                }
            }
            
            Section(header: Text("Ingredients")) {
                Button("Add Ingredient", systemImage: "plus") {
                    showSheet.toggle()
                }.foregroundStyle(.link)
                
                List {
                    ForEach(Array(ingredients.keys)) { food in
                        Text("\(ingredients[food]!.formatted(.number.notation(.compactName)))g \(food.name)")
                    }.onDelete(perform: delete)
                }
                
            }.navigationLinkIndicatorVisibility(.hidden)
        }
        .navigationTitle(Text("Create new food"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    context.insert(Food(name: name, nutritional_info: nutritional_info))
                    try? context.save()
                    dismiss()
                }.disabled(name == "" || required_values_not_filled())
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: add_ingredients) {
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
    
    func add_ingredients() {
        nutritional_info = [:]
        
        for i in ingredients.keys {
            for n in i.nutritional_info.keys {
                nutritional_info[n, default: 0] += (i[n] ?? 0) * (ingredients[i]! / 100)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let ndx = offsets.first {
            let item = ingredients.keys.sorted(by: {$0.timestamp > $1.timestamp})[ndx]
            
            for n in item.nutritional_info.keys {
                nutritional_info[n]! -= item.nutritional_info[n]! * (ingredients[item]! / 100)
            }
            
            ingredients.removeValue(forKey: item)
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
            TextField(required ? "Required" : "0", value: $value, format: .number)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        NewFoodView()
            .sampleDataContainer()
    }
}
