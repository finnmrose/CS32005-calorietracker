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
                let d = Day(index)
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
    
    static let sampleData = Log([.now: Day.sampleData.first!])
}
