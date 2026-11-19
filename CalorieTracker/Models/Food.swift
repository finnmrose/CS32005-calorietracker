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
        case id, name, portion, calories, nutritional_info, ingredients, timestamp
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
    
    var timestamp: Date
    var deleted: Bool = false
    
    var portion_type: Portion
    
    var description: String {
        return self.name
    }
    
    var verbose: String {
        var output = "\"\(self.name)\":\n"
        for key in nutritional_info.keys.sorted(by: {$0.rawValue < $1.rawValue}) {
            output += "\t\(key.short_name): \(nutritional_info[key]!) / \(self.portion_type.unit)\n"
        }
        
        return output
    }
    
    init(name: String, portion_type: Portion, calories: Float = 0, carbs: Float = 0, protein: Float = 0, fats: Float = 0) {
        self.name = name
        self.portion_type = portion_type
        self.nutritional_info = [.calories:calories, .carbohydrates:carbs, .protein:protein, .fats:fats]
        self.timestamp = .now
    }
    
    init(name: String, portion_type: Portion, nutritional_info: [Food.Nutrient: Float] = [:]) {
        self.name = name
        self.portion_type = portion_type
        self.nutritional_info = nutritional_info
        self.timestamp = .now
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
        Food(name: "Banana", portion_type: .count, calories:105, carbs:27, protein:1.3, fats:0.39),
        Food(name: "Apple", portion_type: .count, calories:95, carbs:25.1, protein:0.47, fats:0.31),
        Food(name: "Porridge", portion_type: .weight, calories: 0.71, carbs:0.12, protein:0.025, fats:0.015),
        Food(name: "Whole Milk", portion_type: .volume, calories: 0.63, carbs: 0.049, protein: 0.032, fats: 0.034),
    ]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.portion_type = try container.decode(Portion.self, forKey: .portion)
        self.nutritional_info = try container.decode(Dictionary<Food.Nutrient, Float>.self, forKey: .nutritional_info)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(portion_type, forKey: .portion)
        try container.encode(nutritional_info, forKey: .nutritional_info)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
