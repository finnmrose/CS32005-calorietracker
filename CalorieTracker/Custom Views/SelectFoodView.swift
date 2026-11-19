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
    @Query(sort: \Food.timestamp, order:.reverse) private var foods: [Food]    
    @State private var searchQuery: String = ""
    var isSearching: Bool { return !searchQuery.isEmpty }
    
    var results: [Food] {
        guard isSearching else {return foods.filter{!$0.deleted}}
        return foods.filter { food in
            food.name
                .lowercased()
                .contains(searchQuery.lowercased())
            &&
            !food.deleted
        }
    }
    
    let meal: String
    let date: Date
    
    init (_ meal: String, _ date: Date) {
        self.meal = meal
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
                
                Section (
                    header: Text("Saved Foods")
                        .searchable(text: $searchQuery)
                        .textInputAutocapitalization(.never)
                ) {
                    List {
                        ForEach(results.sorted {$0.timestamp > $1.timestamp}) { food in
                            NavigationLink {
                                LogFoodView(food, date: self.date, meal: self.meal)
                            } label: {
                                HStack {
                                    Text(food.name)
                                    Spacer()
                                    Text(food.calories.formatted(.number.notation(.compactName)) + (food.portion_type.isContinuous ? " / \(food.portion_type.unit)": ""))
                                }
                            }
                        }.onDelete(perform: delete)
                    }
                }
            }.navigationTitle(Text("Select Food"))
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            // foods don't actually get deleted just hidden from the saved foods list
            // since some food instances could refer to them
            foods[index].deleted = true
        }
    }
}
