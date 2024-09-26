//
//  gradesViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import Foundation

final class CoursesViewModel {
    var courses: [course] = []
    
    func createCourse(name: String, isPoints: Bool) {
        courses.append(course(name: name, isPoints: isPoints))
    }
    
    func deleteCourse(at index: Int) {
        courses.remove(at: index)
    }
    
    
}
