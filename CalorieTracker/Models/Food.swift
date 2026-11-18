//
//  Food.swift
//  CalorieTracker
//
//  Created by Rose on 11/11/2026.
//

import Foundation
import SwiftData
import SwiftUI

/* Generic food class that meals and ingredients build upon */

@Model
class Food : Identifiable, Codable, Hashable, CustomStringConvertible {
    enum CodingKeys: CodingKey {
        case id, name, calories, nutritional_info, ingredients, timestamp
    }
    
    enum Nutrient : Int, CaseIterable, Codable, Identifiable {
        var id: Int {return self.rawValue}
        case calories = 0
        case carbohydrates = 1
        case protein = 2
        case fats = 3
        
        var long_name: String {
            switch self {
            case .calories: return "Calories"
            case .carbohydrates: return "Total Carbohydrate"
            case .protein: return "Protein"
            case .fats: return "Total Fat"
            }
        }
        
        var short_name: String {
            switch self {
            case .carbohydrates:
                return "Carbs"
            case .fats:
                return "Fats"
            default:
                return self.long_name
            }
        }
        
        var color: Color {
            switch self {
            case .carbohydrates:
                return .purple
            case .protein:
                return .green
            case .fats:
                return .orange
            default:
                return .blue
            }
        }
        
        var required: Bool {
            switch self {
            case .calories:
                return true
            default:
                return false
            }
        }
    }
    
    var id: UUID = UUID()
    
    var name: String
    var calories: Float {nutritional_info[.calories] ?? 0}
    
    var nutritional_info: [Food.Nutrient: Float]
    var ingredients: [FoodInstance]
    
    var timestamp: Date
    
    var description: String {
        return self.name
    }
    
    init(name: String, calories: Float = 0, carbs: Float = 0, protein: Float = 0, fats: Float = 0) {
        self.name = name
        self.nutritional_info = [.calories:calories, .carbohydrates:carbs, .protein:protein, .fats:fats]
        self.ingredients = []
        self.timestamp = .now
    }
    
    init(name: String, nutritional_info: [Food.Nutrient: Float] = [:]) {
        self.name = name
        self.nutritional_info = nutritional_info
        self.ingredients = []
        self.timestamp = .now
    }
    
    init(name: String, ingredients: [FoodInstance]) {
        self.name = name
        self.nutritional_info = [:]
        self.ingredients = ingredients
        self.timestamp = .now
        
        for food in ingredients {
            for k in food.nutritional_info.keys {
                self.nutritional_info[k] = self.nutritional_info[k] ?? 0 + food.nutritional_info[k]!
            }
        }
    }
    
    subscript(index: Food.Nutrient) -> Float? {
        get {
            return self.nutritional_info[index]
        }
        set (newValue) {
            return self.nutritional_info[index] = newValue
        }
    }
    
    static let sampleData = [
        Food(name: "Banana", calories:89, carbs:22.8, protein:1.1, fats:0.33),
        Food(name: "Apple", calories:52, carbs:13.8, protein:0.26, fats:0.17),
        Food(name: "Porridge", calories: 71, carbs:12, protein:2.5, fats:1.5),
        Food(name: "One Big Calorie", calories: 1),
        Food(name: "Protein Cube", protein: 100)
    ]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.nutritional_info = try container.decode(Dictionary<Food.Nutrient, Float>.self, forKey: .nutritional_info)
        self.ingredients = try container.decode(Array<FoodInstance>.self, forKey: .ingredients)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(nutritional_info, forKey: .nutritional_info)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
