//
//  SelectFoodView.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//
//  A list of all pre-saved foods
//  Contains an option to create a new one
//  Or to select

import SwiftUI
import SwiftData

struct SelectFoodView: View {
    @Query(
        sort: \Food.timestamp,
        order:.reverse
    ) private var foods: [Food]
    
    @Environment(\.modelContext) private var context
    @Environment(Log.self) private var log
    
    
    @State private var searchQuery: String = ""
    var isSearching: Bool { return !searchQuery.isEmpty }
    
    var results: [Food] {
        guard isSearching else {return foods.filter{!$0.deleted}.sorted(by: {$0.timestamp > $1.timestamp})}
        return foods.filter { food in
            food.name
                .lowercased()
                .contains(searchQuery.lowercased())
            &&
            !food.deleted
        }.sorted(by: {$0.timestamp > $1.timestamp})
    }
    
    @Binding var meal: Meal
    let date: Date
    
    init (_ meal: Binding<Meal>, _ date: Date) {
        self._meal = meal
        self.date = date
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        NewFoodView()
                    } label: {
                        Label("Create new food", systemImage: "plus")
                            .foregroundStyle(.link)
                    }.navigationLinkIndicatorVisibility(.hidden)
                }
                
                if !foods.filter({!$0.deleted}).isEmpty {
                    Section (
                        header: Text("Saved Foods")
                            .searchable(text: $searchQuery)
                            .textInputAutocapitalization(.never)
                    ) {
                        List {
                            ForEach(results.sorted {$0.timestamp > $1.timestamp}) { food in
                                NavigationLink {
                                    LogFoodView(food, date: self.date, meal: $meal)
                                } label: {
                                    HStack {
                                        Text(food.name)
                                        Spacer()
                                        Text((food.calories * food.portion_type.input_scale).formatted(.number.notation(.compactName)) + "kcal / " + food.portion_type.alt_unit)
                                    }
                                }
                            }.onDelete(perform: delete)
                        }
                    }
                }
            }
            .navigationTitle(Text("Log Food"))

        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            // foods don't actually get deleted just hidden from the saved foods list
            // since some food instances could refer to them
            results[index].deleted = true
        }
        try? context.save()
    }
}
