//
//  NewFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData
import VisionKit

struct NewFoodView : View {
    @Query(filter: #Predicate<Food> { food in
        !food.deleted}
    ) private var foods: [Food]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State var newFood: Food = Food()
    
    @State private var ingredients: [Food: Float] = [:]
    @State private var showSheet: Bool = false

    @State private var fetching: Bool = false
    @State private var isShowingScanner: Bool = false
    @State private var foundBarcode: String = ""
    
    var scannerAvailable: Bool {
        return DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    var body : some View {
        Form {
            if ingredients.isEmpty, scannerAvailable {
                Section {
                    HStack {
                        Button("Scan Barcode", systemImage: "camera.viewfinder") {
                            isShowingScanner = true
                            fetching = false
                        }
                        Spacer()
                        if !foundBarcode.isEmpty {
                            ProgressView().foregroundStyle(.link)
                        }
                    }
                }
            }
            
            HStack {
                Text("Name")
                TextField("Required", text: $newFood.name)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
                
            }
            Picker("Portion Type", selection: $newFood.portion_type.animation()) {
                ForEach(Portion.allCases) { portion in
                    Text(portion.description)
                }
            }.disabled(!ingredients.isEmpty)
            
            if !newFood.name.isEmpty && !newFood.portion_type.isNone || !ingredients.isEmpty {
                Section(header: Text("Nutritional Information per \(newFood.portion_type.alt_unit)")) {
                    ForEach(Food.Nutrient.allCases) { nutrient in
                        FloatField(label: "\(nutrient.long_name) \(nutrient.alt_unit)", value: $newFood.nutritional_info[nutrient], required: nutrient.required)
                    }
                }
            }
            if !foods.isEmpty {
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
        }
        .navigationTitle(Text("Create new food"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    newFood.nutritional_info = newFood.nutritional_info.mapValues({$0 / newFood.portion_type.input_scale})
                    
                    if !ingredients.isEmpty {
                        for (key, value) in ingredients {
                            newFood.ingredients.append(FoodInstance(key, value))
                        }
                    }
                    
                    context.insert(newFood)
                    try? context.save()
                    dismiss()
                }.disabled(newFood.name.isEmpty || newFood.portion_type.isNone || required_values_not_filled())
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: update_ingredients) {
            NavigationStack {
                SearchFoodView(ingredients: $ingredients)
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            BarcodeScannerView { barcode in
                self.foundBarcode = barcode.payloadStringValue ?? ""
                isShowingScanner = false
                Task {
                    do {
                        newFood = try await BarcodeAPI.lookupBarcode(foundBarcode)
                        self.foundBarcode = ""
                        ingredients = [:]
                    } catch {
                        self.foundBarcode = ""
                        print(error)
                    }
                }
            } onCancel: {
                isShowingScanner = false
            }.presentationDragIndicator(.visible)
        }
    }
    
    func required_values_not_filled() -> Bool {
        for nutrient in Food.Nutrient.allCases {
            if nutrient.required && !newFood.nutritional_info.keys.contains(nutrient) {
                return true
            }
        }
        return false
    }
    
    func update_ingredients() {
        if !ingredients.isEmpty {
            newFood.portion_type = .count
            newFood.name = newFood.name.isEmpty ? "New Food" : newFood.name
        }
        
        newFood.nutritional_info = [:]
        
        for i in ingredients.keys {
            for n in i.nutritional_info.keys {
                newFood.nutritional_info[n, default: 0] += (i[n] ?? 0) * ingredients[i]!
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
            Spacer()
            TextField(required ? "Required" : "0", value: $value, format: .number.precision(.fractionLength(0...2)))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .frame(width:100)
        }
    }
}

#Preview {
    NavigationStack {
        NewFoodView()
            .sampleDataContainer()
    }
}
