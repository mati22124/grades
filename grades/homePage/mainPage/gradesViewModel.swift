//
//  gradesViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/30/24.
//

import Foundation

@MainActor
final class gradesViewModel: ObservableObject {
    @Published var user: DBUser? = nil
    
    @Published var courses: [course] = []
    
    @Published private(set) var currentUser: authResult? = nil

    func loadCurrentUser() async throws {
        currentUser = try authManager.shared.getAuthUser()
        if let u = currentUser {
            do { // Get user handle
                user = try await userManager.shared.getUser(userId: u.uid)
                print("get user")
            } catch {
                if error.localizedDescription == "The data couldn’t be read because it is missing." {
                    try userManager.shared.setUser(data: DBUser(uid: u.uid, name: "", email: u.email ?? ""))
                    print("Set user ran")
                } else {
                    throw coursesError.noUserInFirebase
                }
            }
            
            do {
                courses = try await coursesManager.shared.getCourses(userId: u.uid)
            } catch {
                print("Error getting courses: \(error)")
            }
        } else {
            throw authError.noUser
        }
    }
    
    func addCourse(name: String, teacher: String, isPoints: Bool) throws {
        if name.isEmpty || teacher.isEmpty { throw coursesError.courseEmpty }
        guard let _ = user else { throw authError.noUser }
        let newCourse = course(name: name, teacher: teacher, isPoints: isPoints)
        guard let _ = user else { throw authError.noUser }
        courses.append(newCourse)
        try? publishCourses()
    }
    
    func publishCourses() throws {
        if let user = user {
            try coursesManager.shared.setCourses(uid: user.uid, data: courses)
        } else {
            throw authError.noUser
        }
    }
}

enum coursesError: Error {
    case courseEmpty
    case noUserInFirebase
}
