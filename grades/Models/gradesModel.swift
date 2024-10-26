//
//  gradesModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import Foundation

class course: Codable, Identifiable {
    var name: String
    var grades: [grade]
    var categories: [categoy]
    var isPoints: Bool
    var id: String
    
    // add func vars for average
    var average: Float {
        if isPoints {
            return grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points })
        } else {
            //figure out logic later
            return 0
        }
    }
    
    init(name: String, isPoints: Bool) {
        self.name = name
        self.grades = []
        self.categories = []
        self.isPoints = isPoints
        self.id = UUID().uuidString
    }
}

struct grade: Codable, Identifiable {
    var points: Float
    var earned: Float
    var weight: Float
    var date: Date
    var id: UUID = UUID()
}

struct categoy: Codable, Identifiable {
    var grades: [grade]
    var weight: Float
    var id: UUID = UUID()
}
