//
//  gradesModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import Foundation

class course: Codable, Identifiable, Equatable {
    static func == (lhs: course, rhs: course) -> Bool {
        lhs.id == rhs.id
    }
    
    
    var name: String
    var teacher: String
    var grades: [grade]
    var categories: [categoy]
    var isPoints: Bool
    var id: String
    
    // add func vars for average
    var average: Double {
        if isPoints {
            if grades.isEmpty { return 0 }
            let x = grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.earned) }) / grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.points) }) // add ternary operator for calculations.
            return x*100
        } else {
            //figure out logic later
            return 0
        }
    }
    
    var phantomAverage: Double {
        if isPoints {
            if grades.isEmpty { return 0 }
            let x = grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points }) // add ternary operator for calculations.
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

struct grade: Codable, Identifiable, Equatable {
    var name: String
    var points: Double
    var earned: Double
    var weight: Double
    var date: Date
    var isPhantom: Bool
    var id: UUID = UUID()
    
    var percentage: Double {
        return (earned/points)*100
    }
    
    init(name: String, points: Double, earned: Double, weight: Double, date: Date, isPhantom: Bool = false) {
        self.name = name
        self.points = points
        self.earned = earned
        self.weight = weight
        self.date = date
        self.isPhantom = isPhantom
        self.id = UUID()
    }
}

struct categoy: Codable, Identifiable {
    var grades: [grade]
    var weight: Double
    var id: UUID = UUID()
}
