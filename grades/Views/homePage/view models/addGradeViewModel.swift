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
    
    
    func saveGrade(_ course: inout course) throws{
        // Create new grade and add to course
        // You'll need to implement this based on your data model
        let newGrade = grade(
            name: name,
            points: Double(totalPoints) ?? 0,
            earned: Double(pointsEarned) ?? 0,
            weight: 1,
            date: date
        )
        
        course.grades.append(newGrade)
        try coursesManager.shared.setCourse(data: course)
    }
}
