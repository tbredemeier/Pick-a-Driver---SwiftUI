//
//  DataStore.swift
//  Pick a Driver
//
//  Created by Tom Bredemeier on 1/5/22.
//

import Foundation

class DataStore: ObservableObject {
    var period: String
    @Published var students: [Student] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(students) {
                UserDefaults.standard.set(encoded, forKey: "Pick a Driver: \(period) Period")
            }
        }
    }
    
    init(period: String) {
        self.period = period
        if let data = UserDefaults.standard.data(forKey: "Pick a Driver: \(period) Period") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Student].self, from: data) {
                self.students = decoded
                return
            }
        }
        students = []
    }
}

struct Student: Identifiable, Codable {
    var id = UUID()
    var name = String()
    var tapped = false
    var eliminated = false
}

