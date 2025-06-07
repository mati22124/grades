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
    var markingPeriod: Int?
    var year: Int?
    var credits: Double?
    
    // add func vars for average
    var average: Double {
        if grades.isEmpty { return 0 }
        if isPoints {
            let x = grades.reduce(0, { $0 + ($1.isPhantom ? 0 : ($1.earned * $1.weight)) }) / grades.reduce(0, { $0 + ($1.isPhantom ? 0 : ($1.points * $1.weight)) })
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
            let x = grades.reduce(0, { $0 + ($1.earned * $1.weight) }) / grades.reduce(0, { $0 + ($1.points * $1.weight) })
            return x*100
        } else {
            var total: Double = 0
            for i in categories {
                total += i.phantomAverage
            }
            return total
        }
    }
    
    init(name: String, teacher: String, isPoints: Bool, credits: Double? = nil) {
        self.name = name
        self.grades = []
        self.categories = []
        self.isPoints = isPoints
        self.teacher = teacher
        self.id = UUID().uuidString
        self.credits = credits
    }
    
    init(name: String, teacher: String, isPoints: Bool, grades: [grade], credits: Double? = nil) {
        self.name = name
        self.grades = grades
        self.categories = []
        self.isPoints = isPoints
        self.teacher = teacher
        self.id = UUID().uuidString
        self.credits = credits
    }
    
    init(name: String, teacher: String, grades: [grade], categories: [category], credits: Double? = nil) {
        self.name = name
        self.grades = grades
        self.categories = categories
        self.isPoints = false
        self.teacher = teacher
        self.id = UUID().uuidString
        self.credits = credits
    }
}

struct grade: Codable, Identifiable, Equatable, Hashable {
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

struct category: Codable, Identifiable, Equatable, Hashable {
    var name: String
    var grades: [grade]
    var weight: Double
    var id: UUID = UUID()
    
    // MARK: some schools either temporarily change the weights or return it as 100. rn do temp change weights but ur gunna need to inc both.
    var average: Double {
        if grades.isEmpty { return weight*100 }
        let x = grades.reduce(0, { $0 + ($1.isPhantom ? 0 : ($1.earned * $1.weight)) }) / grades.reduce(0, { $0 + ($1.isPhantom ? 0 : ($1.points * $1.weight)) })
        if x.isNaN { return 0 }
        return x*weight*100
    }
    
    var phantomAverage: Double {
        if grades.isEmpty { return weight*100 }
        let x = grades.reduce(0, { $0 + ($1.earned * $1.weight) }) / grades.reduce(0, { $0 + ($1.points * $1.weight) })
        if x.isNaN { return 0 }
        return x*weight*100
    }
}

// Final grade from previous years - just stores the letter grade
struct finalGrade: Codable, Identifiable, Equatable {
    var name: String // Course name
    var teacher: String
    var letterGrade: String // A+, A, A-, B+, etc.
    var year: Int
    var markingPeriod: Int?
    var credits: Double
    var id: String
    
    init(name: String, teacher: String, letterGrade: String, year: Int, markingPeriod: Int? = nil, credits: Double) {
        self.name = name
        self.teacher = teacher
        self.letterGrade = letterGrade
        self.year = year
        self.markingPeriod = markingPeriod
        self.credits = credits
        self.id = UUID().uuidString
    }
}
