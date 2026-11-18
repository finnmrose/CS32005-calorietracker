//
//  Meal.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import Foundation
import SwiftData

@Model
class Meal : Identifiable {
    var id: UUID = UUID()
    var label: String
    var foods: [FoodInstance]
    var sortIndex: Int
    
    init(_ label: String, foods: [FoodInstance] = [], sortIndex: Int = -1) {
        self.label = label
        self.sortIndex = -1
        self.foods = foods
    }
    
    subscript (index: Int) -> FoodInstance {
        get {
            return foods[index]
        } set (newValue) {
            return foods[index] = newValue
        }
    }
    
    func append(_ new: FoodInstance) {
        foods.append(new)
    }
    
    static let sampleData: [Meal] = [
        Meal("Breakfast", foods: FoodInstance.sampleData, sortIndex: 0),
        Meal("Dinner", foods: FoodInstance.sampleData, sortIndex: 2),
    ]
}
