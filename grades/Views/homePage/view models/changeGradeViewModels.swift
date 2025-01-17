//
//  addGradeViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 11/1/24.
//

import Foundation

// View Model
class AddGradeViewModel: ObservableObject {
    @Published var name = ""
    @Published var pointsEarned = ""
    @Published var totalPoints = ""
    @Published var selectedCategory = ""
    @Published var date = Date()
    
    var isValidInput: Bool {
        !name.isEmpty &&
        !pointsEarned.isEmpty &&
        !totalPoints.isEmpty &&
        (Double(pointsEarned) ?? 0) >= 0 &&
        (Double(totalPoints) ?? 0) > 0
    }
    
    
    func saveGrade(_ course: inout course, isPhan: Bool = false) throws{
        let newGrade = grade(
            name: name,
            points: Double(totalPoints) ?? 0,
            earned: Double(pointsEarned) ?? 0,
            weight: 1,
            date: date,
            isPhantom: isPhan
        )
        
        course.grades.append(newGrade)
        try coursesManager.shared.setCourse(data: course)
    }
}

class editGradeViewModel: ObservableObject {
    @Published var pointsEarned: String
    @Published var totalPoints: String
    
    init(grade: grade) {
        pointsEarned = grade.earned.removeZerosFromEnd()
        totalPoints = grade.points.removeZerosFromEnd()
    }
    
    var isValidInput: Bool {
        !pointsEarned.isEmpty &&
        !totalPoints.isEmpty &&
        (Double(pointsEarned) ?? 0) >= 0 &&
        (Double(totalPoints) ?? 0) > 0
    }
    
    
    func saveGrade(course: inout course, grade newGrade: grade) throws {
        var accGrade = newGrade
        let indop = course.grades.firstIndex(where: {$0.id == newGrade.id})
        if let indop {
            accGrade.earned = Double(pointsEarned) ?? 0
            accGrade.points = Double(totalPoints) ?? 0
            course.grades[indop] = accGrade
        }
        try coursesManager.shared.setCourse(data: course)
    }
}
