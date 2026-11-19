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
    var portion_type: Portion { return food.portion_type }
    var description: String {
        return "(\(self.amount.formatted(.number.notation(.compactName)))) \"\(self.name)\""
    }
    
    var amount_formatted: String {
        switch portion_type {
        case .weight, .volume:
            return (amount > 1000) ? "\((amount / 1000).formatted(UTILS.SHORT_FORMAT))\(portion_type.big_unit)" : "\(amount.formatted(UTILS.SHORT_FORMAT))\(portion_type.unit)"
        case .count:
            return amount.formatted(.number.notation(.compactName))
        default:
            return ""
        }
    }
    
    init(_ food: Food, amount: Float) {
        self.food = food
        self.amount = amount
    }
    
    init(_ food: Food, _ amount: Float) {
        self.food = food
        self.amount = amount
    }
    
    subscript(index: Food.Nutrient) -> Float? {
        get {
            return self.nutritional_info[index]
        }
    }
    
    static let sampleData = [
        FoodInstance(Food.sampleData[0], 0.5),
        FoodInstance(Food.sampleData[1], 1),
        FoodInstance(Food.sampleData[2], 100),
        FoodInstance(Food.sampleData[2], 1100),
        FoodInstance(Food.sampleData[2], 0.001),
        FoodInstance(Food.sampleData[3], 200),
        FoodInstance(Food.sampleData[3], 25200),
    ]
}
