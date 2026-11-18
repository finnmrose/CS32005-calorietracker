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
    
    @Binding var ingredients: [FoodInstance]
    
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var body: some View {
        List {
            ForEach(isSearching ? searchResults.sorted {$0.timestamp > $1.timestamp} : foods.sorted {$0.timestamp > $1.timestamp}) { food in
                SearchResult(food: food)
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
        }
    }
}

struct SearchResult: View {
    @Environment(\.dismiss) private var dismiss
    @State var amount: Float? = nil
    let food: Food
    
    var body: some View {
        HStack {
            Text(food.name)
            Spacer()
            Stepper {
                TextField(value: $amount, format: .number) {
                    Text("\((amount ?? 0).formatted(.number))")
                }
            } onIncrement: {
                amount = (amount ?? 0) + 100
            } onDecrement: {
                amount = (amount ?? 0 <= 100) ? nil : amount! - 100
            }.multilineTextAlignment(.trailing)
        }
    }
}
