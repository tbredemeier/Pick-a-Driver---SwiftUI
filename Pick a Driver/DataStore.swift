//
//  DataStore.swift
//  Pick a Driver
//
//  Created by Tom Bredemeier on 1/5/22.
//

import Foundation

class DataStore: ObservableObject {
    @Published var persons: [Person] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(persons) {
                UserDefaults.standard.set(encoded, forKey: "Pick a Driver")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Pick a Driver") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Person].self, from: data) {
                self.persons = decoded
                return
            }
        }
        persons = []
    }
}

struct Person: Identifiable, Codable {
    var id = UUID()
    var name = String()
}
