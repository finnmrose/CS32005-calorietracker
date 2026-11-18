//
//  SampleData.swift
//  CalorieTracker
//
//  Created by Rose on 12/11/2026.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init() {
        let schema = Schema([
            Food.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Couldn't create modelContainer: \(error)")
        }
        
    }
    
    private func insertSampleData() {
        for food in Food.sampleData {
            context.insert(food)
        }
    }
    
    
}

