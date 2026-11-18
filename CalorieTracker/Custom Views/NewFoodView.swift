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
    
    @State private var ingredients: [FoodInstance] = []
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
                        .onChange(of: ingredients) {
                            for key in nutritional_info.keys {
                                nutritional_info[key] = ingredients.reduce(0, {$0 + ($1.nutritional_info[key] ?? 0)})
                            }
                        }
                }
            }
            
            Section(header: Text("Ingredients")) {
                Button("Add Ingredient", systemImage: "plus") {
                    showSheet.toggle()
                }.foregroundStyle(.link)
                List ($ingredients, editActions: .delete) { $food in
                    Text(food.name)
                }
            }.navigationLinkIndicatorVisibility(.hidden)
        }
        .navigationTitle(Text("Create new food"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    context.insert(Food(name: name, nutritional_info: nutritional_info))
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
            .modelContainer(SampleData.shared.modelContainer)
    }
}
