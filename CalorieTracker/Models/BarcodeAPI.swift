//
//  BarcodeAPI.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//
//
//  modelled after https://medium.com/@codable-kapil/different-ways-of-getting-data-from-an-api-endpoint-in-swift-8b1d5933c9dd
//

import Foundation

enum BarcodeAPI {
    
    static func getData(_ food: Food) async throws -> Food {
        let e = JSONEncoder()
        e.outputFormatting = .prettyPrinted
        
        let d = try e.encode(food)
        print(String(data: d, encoding: .utf8) ?? "nil")
        return food
    }
    
    static func lookupBarcode(_ query: String) async throws -> Food {
        let urlString = "http://172.20.10.4:10000/" + query
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        
        guard let url = URL(string: urlString) else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]) }
        
        let session = URLSession(configuration: config)
        
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server Error"])
        }
        try? await Task.sleep(nanoseconds: 2000000000)

        let info = try JSONDecoder().decode(Food.self, from: data)
        return info
    }
}
