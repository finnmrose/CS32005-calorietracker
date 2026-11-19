//
//  DataContainer.swift
//  CalorieTracker
//
//  Created by Rose on 18/11/2026.
//

import SwiftData
import Foundation
import SwiftUI

@MainActor
@Observable
class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(includeSampleData: Bool = false) {
        let schema = Schema([
            Food.self,
            Log.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleData)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            if includeSampleData {
                loadSampleData()
            } else {
                context.insert(Log())
            }
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func loadSampleData() {
        for food in Food.sampleData {
            context.insert(food)
        }
        
        let log = Log()
        log[.now] = Day.sampleData[0]
        context.insert(log)
    }
    
    func get_log() -> Log {
        let data = try? self.context.fetch(FetchDescriptor<Log>())
        return data?.first ?? Log()
    
    }
}


private let sampleContainer = DataContainer(includeSampleData: true)

extension View {
    func sampleDataContainer() -> some View {
        let request = FetchDescriptor<Log>()
        let data = try? sampleContainer.context.fetch(request)
        
        return self
            .environment(sampleContainer)
            .environment(data?.first ?? Log())
            .modelContainer(sampleContainer.modelContainer)
    }
    
    func withLog(_ dataContainer: DataContainer) -> some View {
        let request = FetchDescriptor<Log>()
        let data = try? dataContainer.context.fetch(request)
        
        return self.environment(data?.first ?? Log())
    }
}
