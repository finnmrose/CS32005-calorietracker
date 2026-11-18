//
//  Meal.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//

import Foundation
import SwiftData

@Model
class Meal : Identifiable, Codable, CustomStringConvertible {
    enum CodingKeys: CodingKey {
        case id, label, foods, sortIndex
    }
    
    var id: UUID = UUID()
    var label: String
    var foods: [FoodInstance]
    var sortIndex: Int
    
    var description: String {
        return "\"\(self.label)\": [" + foods.map({"\($0)"}).joined(separator: ", ") + "]"
    }
    
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.label = try container.decode(String.self, forKey: .label)
        self.foods = try container.decode(Array<FoodInstance>.self, forKey: .foods)
        self.sortIndex = try container.decode(Int.self, forKey: .sortIndex)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(label, forKey: .label)
        try container.encode(foods, forKey: .foods)
        try container.encode(sortIndex, forKey: .sortIndex)
    }
}
