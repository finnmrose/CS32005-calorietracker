//
//  FoodInstance.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import Foundation
import SwiftData

struct FoodInstance: Identifiable, Codable, Equatable, CustomStringConvertible {
    
    var id: UUID = UUID()
    let food: Food
    var amount: Float
    var nutritional_info: [Food.Nutrient: Float] {
        return food.nutritional_info.mapValues { value in
            return value * amount
        }
    }
    var name: String { return food.name }
    var calories: Float { return food.calories * amount }
    var description: String {
        return "(\(self.amount.formatted(.number.notation(.compactName)))) \"\(self.name)\""
    }
    
    init(_ food: Food, amount: Float) {
        self.food = food
        self.amount = amount / 100
    }
    
    init(_ food: Food, _ amount: Float) {
        self.food = food
        self.amount = amount / 100
    }
    
    subscript(index: Food.Nutrient) -> Float? {
        get {
            return self.nutritional_info[index]
        }
    }
    
    static let sampleData = [
        FoodInstance(Food.sampleData[0], 100),
        FoodInstance(Food.sampleData[1], 200),
        FoodInstance(Food.sampleData[2], 30),
        FoodInstance(Food.sampleData[2], 100),
    ]
}
