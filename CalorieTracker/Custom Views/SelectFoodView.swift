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
    
    @State private var newFood: Food?
    @Binding var path: NavigationPath
    
    let meal: String?
    let date: Date?
    
    init (_ meal: String? = nil, _ date: Date? = nil, path: Binding<NavigationPath>) {
        self.meal = meal
        self.date = date
        self._path = path
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
                
                Section(header: Text("Saved Foods")) {
                    List {
                        ForEach(foods.filter({!$0.deleted})) { food in
                            NavigationLink {
                                LogFoodView(food, date: self.date ?? .now, meal: self.meal, path: $path)
                            } label: {
                                HStack {
                                    Text(food.name)
                                    Spacer()
                                    Text(food.calories.formatted(.number.notation(.compactName)))
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
