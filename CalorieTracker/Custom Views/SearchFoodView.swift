//
//  SearchFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import SwiftUI
import SwiftData

struct SearchFoodView: View {
    
    @Query private var foods: [Food]
    
    @State private var searchResults: [Food] = []
    @State private var searchQuery: String = ""
    
    @Binding var ingredients: [Food: Float]
    
    var results: [Food] {
        return isSearching ? searchResults.filter{!$0.deleted}.sorted{$0.timestamp > $1.timestamp} : foods.filter{!$0.deleted}.sorted{$0.timestamp > $1.timestamp}
    }
    
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var body: some View {
        List {
            ForEach(results) { food in
                SearchResult(food: food, ingredients: $ingredients)
            }
        }
        .searchable(
            text: $searchQuery,
            placement: .toolbarPrincipal
        )
        .textInputAutocapitalization(.never)
        .onChange(of: searchQuery) {
            self.fetchResults(for: searchQuery)
        }
    }
    
    private func fetchResults(for query: String) {
        searchResults = foods.filter { food in
            food.name
                .lowercased()
                .contains(searchQuery)
            &&
            !food.deleted
        }
    }
}

struct SearchResult: View {
    @State var amount: Float? = nil
    let food: Food
    @Binding var ingredients: [Food: Float]
    var step_size: Float { return food.portion_type.input_scale}
    
    init(food: Food, ingredients: Binding<[Food: Float]>) {
        self.food = food
        self._ingredients = ingredients
    }
    
    var body: some View {
        HStack {
            Text(food.name + (food.portion_type.isContinuous ? " (\(food.portion_type.unit))" : ""))
            Spacer()
            Stepper {
                TextField(value: $amount, format: .number) {
                    Text("\((amount ?? 0).formatted(.number))")
                }
            } onIncrement: {
                amount = (amount ?? 0) + step_size
            } onDecrement: {
                amount = (amount ?? 0 <= step_size) ? nil : amount! - step_size
            }.multilineTextAlignment(.trailing)
        }.onChange(of: amount) {
            if amount ?? 0 > 0 {
                ingredients[food] = amount
            } else {
                ingredients.removeValue(forKey: food)
            }
        }.task {
            self.amount = ingredients[food]
        }
    }
}
