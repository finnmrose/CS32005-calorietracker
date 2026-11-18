//
//  Day.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import Foundation
import SwiftData

@Model
class Day {
    var date: Date
    var goals: [Food.Nutrient: Float] = [:]
    var data: [Meal]
    var meals: [Meal] {
        return data.sorted {$0.sortIndex < $1.sortIndex}
    }
    
    init(_ date: Date = .now, meals: [Meal] = [Meal("Breakfast", sortIndex: 0), Meal("Lunch", sortIndex: 1), Meal("Dinner", sortIndex: 2), Meal("Other", sortIndex: 3)], goals: [Food.Nutrient: Float] = [.calories:2000, .carbohydrates:260, .protein: 50, .fats:70]) {
        self.date = date
        self.data = meals.sorted {$0.sortIndex < $1.sortIndex}
        self.goals = goals
    }
    
    init(_ date: Date = .now, breakfast: [FoodInstance] = [], lunch: [FoodInstance] = [], dinner: [FoodInstance] = [], other: [FoodInstance] = [], goals: [Food.Nutrient: Float] = [.calories:2000, .carbohydrates:260, .protein: 50, .fats:70]) {
        self.date = date
        self.data = [Meal("Breakfast", foods: breakfast, sortIndex: 0), Meal("Lunch", foods: lunch, sortIndex: 1), Meal("Dinner", foods: dinner, sortIndex: 2), Meal("Other", foods: other, sortIndex: 3)].sorted {$0.sortIndex < $1.sortIndex}
        self.goals = goals
    }
        
    static let sampleData = [
        Day(breakfast:FoodInstance.sampleData, dinner:FoodInstance.sampleData)
    ]
    
    subscript (index: String) -> Meal? {
        get {
            return self.data.first(where: {$0.label == index})
        }
    }
    
    /*
    func total_calories(_ date: Date) -> Float? {
        return data[date]?.reduce(0, {$0 + $1.foods.reduce(0,{$0 + $1.calories})})
    }
    
    func total_value(_ date: Date, key: String) -> Float? {
        return data[date]?.reduce(0, {$0 + $1.foods.reduce(0, {$0 + ($1.nutritional_info[key] ?? 0)})})
    }
     */
    
    func total(field: Food.Nutrient) -> Float {
        return meals.reduce(0, {$0 + $1.foods.reduce(0, {$0 + ($1[field] ?? 0)})})
    }
    
    func isEmpty() -> Bool {
        return data.reduce(0, {$0 + $1.foods.count}) == 0
    }
}
