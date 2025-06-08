//
//  finalGradesViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 6/2/25.
//

import Foundation

@MainActor
final class finalGradesViewModel: ObservableObject {
    @Published var finalGrades: [finalGrade] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var currentUser: authResult? = nil
    
    init() {
        Task {
            await loadFinalGrades()
        }
    }
    
    func loadFinalGrades() async {
        isLoading = true
        do {
            currentUser = try authManager.shared.getAuthUser()
            if let user = currentUser {
                addFinalGradesListener(userId: user.uid)
            }
        } catch {
            errorMessage = "Failed to load final grades: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func addFinalGradesListener(userId: String) {
        finalGradesManager.shared.addFinalGradesListener(userId: userId) { [weak self] finalGrades in
            self?.finalGrades = finalGrades
            print("final grades pulled: \(finalGrades.count)")
        }
    }
    
    func addFinalGrade(name: String, teacher: String, letterGrade: String, year: Int, markingPeriod: Int?, credits: Double, courseLevel: CourseLevel? = nil, isCore: Bool? = nil) throws {
        guard let _ = currentUser else { throw authError.noUser }
        
        let newFinalGrade = finalGrade(
            name: name,
            teacher: teacher,
            letterGrade: letterGrade,
            year: year,
            markingPeriod: markingPeriod,
            credits: credits,
            courseLevel: courseLevel,
            isCore: isCore
        )
        
        try finalGradesManager.shared.addFinalGrade(data: newFinalGrade)
        // The listener will automatically update the array
    }
    
    func removeFinalGrade(_ grade: finalGrade) throws {
        guard let _ = currentUser else { throw authError.noUser }
        try finalGradesManager.shared.removeFinalGrade(data: grade)
        // The listener will automatically update the array
    }
    
    func updateFinalGrade(_ grade: finalGrade) throws {
        guard let _ = currentUser else { throw authError.noUser }
        try finalGradesManager.shared.setFinalGrade(data: grade)
        // The listener will automatically update the array
    }
    
    func removeListener() {
        finalGradesManager.shared.removeListener()
    }
}
