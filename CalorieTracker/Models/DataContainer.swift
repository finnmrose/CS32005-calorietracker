//
//  DataContainer.swift
//  CalorieTracker
//
//  Created following "Develop in Swift Tutorial: Collect, model, and store data"
//  Located at: https://developer.apple.com/tutorials/develop-in-swift/collect-model-and-store-data
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
            Log.self,
            Day.self
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
    
    func reset() {
        
        do {
            try self.context.save()
            try self.context.delete(model: Food.self)
            get_log().reset()
            
            try self.context.save()
        } catch {
            print("Failed to reset DataContainer: \(error)")
        }
    }
}


private let sampleContainer = DataContainer(includeSampleData: true)
private let emptyContainer = DataContainer()

extension View {
    func sampleDataContainer() -> some View {
        let request = FetchDescriptor<Log>()
        let data = try? sampleContainer.context.fetch(request)
        
        return self
            .environment(sampleContainer)
            .environment(data?.first ?? Log())
            .modelContainer(sampleContainer.modelContainer)
    }
    
    func emptyDataContainer() -> some View {
        let request = FetchDescriptor<Log>()
        let data = try? emptyContainer.context.fetch(request)
        
        return self
            .environment(emptyContainer)
            .environment(data?.first ?? Log())
            .modelContainer(emptyContainer.modelContainer)
    }
    
    func withLog(_ dataContainer: DataContainer) -> some View {
        let request = FetchDescriptor<Log>()
        let data = try? dataContainer.context.fetch(request)
        let l = data?.first ?? Log()
        return self.environment(l)
    }
}
