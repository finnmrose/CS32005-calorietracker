//
//  MealView.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import SwiftUI


struct MealView : View {
    
    let meal: Meal
    let date: Date
    @Binding var path: NavigationPath
    
    init(_ meal: Meal, _ date: Date, path: Binding<NavigationPath>) {
        self.meal = meal
        self.date = date
        self._path = path
    }
    
    var body : some View {
        Section (header: MealHeaderView(meal: meal)) {
            ForEach(meal.foods) { food in
                HStack {
                    Text(food.name)
                    Spacer()
                    Text("\(food.calories.formatted(.number.notation(.compactName)))")
                }
            }.onDelete(perform: delete)
            
            NavigationLink {
                SelectFoodView(meal.label, date, path: $path)
            } label: {
                Label("Log Food", systemImage: "plus")
                    .foregroundStyle(.link)
            }.navigationLinkIndicatorVisibility(.hidden)
        }
    }
    
    func delete(at offsets: IndexSet) {
        meal.foods.remove(atOffsets: offsets)
    }
}

struct MealHeaderView : View {
    let meal : Meal
    
    var body : some View {
        HStack {
            Text(meal.label)
            Spacer()
            Text("\(meal.foods.reduce(0, {$0 + $1.calories}).formatted(.number.notation(.compactName)))")
        }
    }
}
