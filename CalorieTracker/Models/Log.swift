//
//  Log.swift
//  CalorieTracker
//
//  Created by Rose on 17/11/2026.
//
//
//  This class maps dates to Day objects basically
//  only one exists ever

import Foundation
import SwiftData

@Model
class Log: CustomStringConvertible {
    
    private var c: Bool = false
    
    var data: [Date: Day]
    // for SOME reason you have to define dictionaries in this super verbose way in this class i dont know why its only here and nowhere else
    var default_goals: [Food.Nutrient: Float] = Dictionary<Food.Nutrient, Float>(uniqueKeysWithValues: [(Food.Nutrient.calories, Float(2000)), (Food.Nutrient.carbohydrates, Float(260)), (Food.Nutrient.protein, Float(100)), (Food.Nutrient.fats, Float(70))])
    var default_meals: [Meal] = [Meal("Breakfast", sortIndex: 0), Meal("Lunch", sortIndex: 1), Meal("Dinner", sortIndex: 2), Meal("Other", sortIndex: 3)]
    
    var description: String {
        return self.data.values.description
    }
    
    init(_ data: [Date: Day] = [:]) {
        self.data = data
    }
    
    subscript (index: Date) -> Day {
        get {
            return data.first(where: {key, value in
                return Calendar.current.isDate(key, inSameDayAs: index)
            })?.value ?? {
                let d = Day(index, meals: default_meals.copy(), goals: default_goals)
                data[index] = d
                return d
            }()
        }
        set (newValue) {
            return data[index] = newValue
        }
    }
    
    // this function just does a something to Log so it properly gets saved via SwiftData
    // otherwise when things only modify objects inside Log (and not Log itself)
    // SwiftData fails to detect something has changed and doesn't save the data
    func commit() {
        c.toggle()
    }
    
    func reset() {
        self.data = [:]
        self.default_goals = Dictionary<Food.Nutrient, Float>(uniqueKeysWithValues: [(Food.Nutrient.calories, Float(2000)), (Food.Nutrient.carbohydrates, Float(260)), (Food.Nutrient.protein, Float(100)), (Food.Nutrient.fats, Float(70))])
        self.default_meals = [Meal("Breakfast", sortIndex: 0), Meal("Lunch", sortIndex: 1), Meal("Dinner", sortIndex: 2), Meal("Other", sortIndex: 3)]
    }
    
    static let sampleData = Log([.now: Day.sampleData.first!])
}
