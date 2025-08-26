//
//  Predators.swift
//  JPApexPredators
//
//  Created by Jim Weaver on 8/25/25.
//

import Foundation

class Predators {
    var apexPredators: [ApexPredator] = []
    init() {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf:url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                apexPredators = try decoder.decode([ApexPredator].self, from:data)
            } catch {
                print("Error decoding JSON data: \(error)")
            }
            
        }
    }
}
