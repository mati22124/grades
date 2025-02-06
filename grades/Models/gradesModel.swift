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
    var categories: [category]
    var isPoints: Bool
    var id: String
    
    // add func vars for average
    var average: Double {
        if grades.isEmpty { return 0 }
        if isPoints {
            let x = grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.earned) }) / grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.points) })
            return x*100
        } else {
            var total: Double = 0
            for i in categories {
                total += i.average
            }
            return total
        }
    }
    
    var phantomAverage: Double {
        if grades.isEmpty { return 0 }
        if isPoints {
            let x = grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points })
            return x*100
        } else {
            var total: Double = 0
            for i in categories {
                total += i.average
            }
            return total
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
    
    init(name: String, teacher: String, grades: [grade], categories: [category]) {
        self.name = name
        self.grades = grades
        self.categories = categories
        self.isPoints = false
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
    var category: String?
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
    
    init(name: String, points: Double, earned: Double, weight: Double, date: Date, category: String, isPhantom: Bool = false) {
        self.name = name
        self.points = points
        self.earned = earned
        self.weight = weight
        self.date = date
        self.isPhantom = isPhantom
        self.category = category
        self.id = UUID()
    }
    
    // init for camera
    init(name: String, points: Double, earned: Double, weight: Double, datee: String) {
        self.name = name
        self.points = points
        self.earned = earned
        self.weight = weight
        self.isPhantom = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let tempDate = dateFormatter.date(from: datee)
        if let rdate = tempDate {
            self.date = rdate
        } else {
            self.date = Date()
        }
    }
}

struct category: Codable, Identifiable {
    var name: String
    var grades: [grade]
    var weight: Double
    var id: UUID = UUID()
    
    var average: Double {
        if grades.isEmpty { return 0 }
        let x = grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.earned) }) / grades.reduce(0, { $0 + ($1.isPhantom ? 0 : $1.points) })
        return x*weight*100
    }
    
    var phantomAverage: Double {
        if grades.isEmpty { return 0 }
        let x = grades.reduce(0, { $0 + $1.earned }) / grades.reduce(0, { $0 + $1.points })
        return x*weight*100
    }
}
