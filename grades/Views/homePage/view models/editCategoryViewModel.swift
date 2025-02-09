//
//  editCategoryViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 2/8/25.
//

import Foundation

class editCategoryViewModel: ObservableObject {
    @Published var course: course
    @Published var categories: [category]
    
    var weightSum: Double {
        categories.reduce(0) { $0 + $1.weight }
    }
    
    var isValid: Bool {
        weightSum == 1
    }
    
    init(course: course) {
        self.course = course
        self.categories = course.categories
    }
    
    func deleteCategory(catToDelete: category?) {
        if let c = catToDelete {
            for grade in c.grades {
                course.grades.removeAll(where: { $0.id == grade.id })
            }
            categories.removeAll(where: { $0.id == c.id })
        }
    }
    
    func saveCategories() throws {
        course.categories = categories
        try coursesManager.shared.setCourse(data: course)
    }
}
