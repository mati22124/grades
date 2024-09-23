//
//  gradesModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import Foundation

class course {
    var name: String
    var grades: [grade]
    var categories: [categoy]
    var isPoints: Bool
    
    // add func vars for average
    
    init(name: String, isPoints: Bool) {
        self.name = name
        self.grades = []
        self.categories = []
        self.isPoints = isPoints
    }
}

struct grade: Codable {
    var points: Float
    var earned: Float
    var weight: Float
    
}

struct categoy {
    var grades: [grade]
    var weight: Float
}
