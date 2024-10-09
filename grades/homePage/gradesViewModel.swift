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
    
    var courses: [course] {
        get {
            if let user = user {
                return user.courses
            } else {
                return []
            }
        }
        set {
            if user != nil {
                user!.courses = newValue
            }
        }
    }
    
    @Published var selectedClass: course? = nil
    @Published private(set) var currentUser: authResult? = nil

    func loadCurrentUser() async throws {
        currentUser = try authManager.shared.getAuthUser()
        if let u = currentUser {
            do {
                user = try await userManager.shared.getUser(userId: u.uid)
                print("get user")
            } catch {
                if error.localizedDescription == "The data couldn’t be read because it is missing." {
                    try userManager.shared.setUser(data: DBUser(uid: u.uid, name: "", email: u.email ?? "", courses: []))
                    print("Set user run")
                } else {
                    throw coursesError.noUserInFirebase
                }
            }
        } else {
            throw coursesError.noUser
        }
    }
    
    func addCourse(name: String, isPoints: Bool) {
        let newCourse = course(name: name, isPoints: isPoints)
        guard let _ = user else { return }
        user!.courses.append(newCourse)
    }
    
    func publish() throws {
        if let user = user {
            try userManager.shared.setUser(data: user)
        } else {
            throw coursesError.noUser
        }
    }
}

enum coursesError: Error {
    case noUser
    case noUserInFirebase
}
