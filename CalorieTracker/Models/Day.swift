//
//  Day.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import Foundation
import SwiftData

@Model
class Day: Codable, CustomStringConvertible {
    enum CodingKeys: CodingKey {
        case date, goals, data
    }
    
    var update: Bool = false
    var date: Date
    var goals: [Food.Nutrient: Float] = [:]
    var data: [Meal]
    var meals: [Meal] {
        return data.sorted {$0.sortIndex < $1.sortIndex}
    }
    
    var description: String {
        return "\n\(date.formatted(date:.abbreviated, time:.omitted)):\n\t" + meals.map({"\($0.sortIndex) \($0)"}).joined(separator: "\n\t") + "\n"
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
    
    subscript (index: String) -> Meal {
        get {
            guard let found = self.data.first(where: {$0.label == index}) else {
                let m = Meal(index, sortIndex: self.maxSortIndex() + 1)
                self.data.append(m)
                return m
            }
            return found
        } set (newValue) {
            guard let i = self.data.firstIndex(where: {$0.label == index}) else {
                self.data.append(newValue)
                return
            }
            self.data[i] = newValue
        }
    }
    
    subscript (index: Meal) -> Meal {
        get {
            guard let found = self.data.first(where: {$0 == index}) else {
                self.data.append(index)
                return index
            }
            return found
        } set (newValue) {
            guard let i = self.data.firstIndex(where: {$0 == index}) else {
                self.data.append(newValue)
                return
            }
            self.data[i] = newValue
        }
    }
    
    func maxSortIndex() -> Int {
        return meals.last?.sortIndex ?? -1
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
    
    var isEmpty: Bool {
        return data.reduce(0, {$0 + $1.foods.count}) == 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.goals = try container.decode(Dictionary<Food.Nutrient, Float>.self, forKey: .goals)
        self.data = try container.decode(Array<Meal>.self, forKey: .data)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(goals, forKey: .goals)
        try container.encode(data, forKey: .data)
    }
    
    func contains(_ meal: Meal) -> Bool {
        return data.contains(meal)
    }
    
    func commit() {
        update.toggle()
    }
}
