//
//  MealView.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import SwiftUI
import SwiftData


struct MealView : View {
    
    @Environment(\.modelContext) private var context
    @Environment(Log.self) private var log
    
    @Binding var meal: Meal
    let date: Date
    
    init(_ meal: Binding<Meal>, _ date: Date) {
        self._meal = meal
        self.date = date
    }
    
    var body : some View {
        Section (header: MealHeaderView(meal: $meal)) {
            ForEach(meal.foods) { food in
                HStack {
                    Text(food.amount_formatted)
                    Text(food.name)
                    Spacer()
                    Text("\(food.calories.formatted(.number.notation(.compactName)))")
                }
            }.onDelete(perform: delete)
            
            NavigationLink {
                SelectFoodView(meal, date)
            } label: {
                Label("Log Food", systemImage: "plus")
                    .foregroundStyle(.link)
            }.navigationLinkIndicatorVisibility(.hidden)
        }
    }
    
    func delete(at offsets: IndexSet) {
        meal.foods.remove(atOffsets: offsets)
        log[date][meal] = meal
        log.commit()
        try? context.save()
    }
}

struct MealHeaderView : View {
    @Binding var meal : Meal
    
    var body : some View {
        HStack {
            Text(meal.label)
            Spacer()
            Text("\(meal.foods.reduce(0, {$0 + $1.calories}).formatted(.number.notation(.compactName)))")
        }
    }
}
