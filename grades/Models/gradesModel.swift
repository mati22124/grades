//
//  gradesModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import Foundation

class course: Codable, Identifiable {
    var name: String
    var teacher: String
    var grades: [grade]
    var categories: [categoy]
    var isPoints: Bool
    var id: String
    
    // add func vars for average
    var average: Double {
        if isPoints {
            let x = grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points })
            return x*100
        } else {
            //figure out logic later
            return 0
        }
    }
    
    init(name: String, teacher: String, isPoints: Bool) {
        self.name = name
        self.grades = []
        self.categories = []
        self.isPoints = isPoints
        self.teacher = teacher
        self.id = UUID().uuidString
    }
    
    init(name: String, teacher: String, isPoints: Bool, grades: [grade]) {
        self.name = name
        self.grades = grades
        self.categories = []
        self.isPoints = isPoints
        self.teacher = teacher
        self.id = UUID().uuidString
    }
}

struct grade: Codable, Identifiable {
    var points: Double
    var earned: Double
    var weight: Double
    var date: Date
    var id: UUID = UUID()
}

struct categoy: Codable, Identifiable {
    var grades: [grade]
    var weight: Double
    var id: UUID = UUID()
}
