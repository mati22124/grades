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
            if grades.isEmpty { return 0 }
            let x = grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points })
            return x*100
        } else {
            //figure out logic later
            return 0
        }
    }
    
    func averageToGrade() -> String {
    if (self.average >= 93) {
        return "A";
    } else if (self.average >= 90) {
        return "A-";
    } else if (self.average >= 87) {
        return "B+";
    } else if (self.average >= 83) {
        return "B";
    } else if (self.average >= 80) {
        return "B-";
    } else if (self.average >= 77) {
        return "C+";
    } else if (self.average >= 73) {
        return "C";
    } else if (self.average >= 70) {
        return "C-";
    } else if (self.average >= 67) {
        return "D+";
    } else if (self.average >= 63) {
        return "D";
    } else if (self.average >= 60) {
        return "D-";
    } else {
        return "F";
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
    var name: String
    var points: Double
    var earned: Double
    var weight: Double
    var date: Date
    var id: UUID = UUID()
    
    var percentage: Double {
        return (earned/points)*100
    }
}

struct categoy: Codable, Identifiable {
    var grades: [grade]
    var weight: Double
    var id: UUID = UUID()
}
