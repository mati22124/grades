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
    
    @Published var showDeleteAllConfirmation: Bool = false
    
    @Published var userSettings: UserSettings? = nil

    func loadCurrentUser() async throws {
        currentUser = try authManager.shared.getAuthUser()
        if let u = currentUser {
            do { // Get user handle
                user = try await userManager.shared.getUser(userId: u.uid)
                print("get user")
            } catch {
                if error.localizedDescription == "The data couldn’t be read because it is missing." {
                    try userManager.shared.setUser(data: DBUser(uid: u.uid, name: "", email: u.email ?? ""))
                    user = DBUser(uid: u.uid, name: "", email: u.email ?? "")
                    print("Set user ran")
                } else {
                    print("real error \(error)")
                    throw coursesError.noUserInFirebase
                }
            }
            addcoursesListener(userId: u.uid)
            addSettingsListener()
        } else {
            throw authError.noUser
        }
    }
    
    func addcoursesListener(userId: String) {
        coursesManager.shared.addCoursesListener(userId: userId) { [weak self] courses in
            self?.courses = courses
            print("courses pulled")
        }
    }
    
    func addCourse(name: String, teacher: String, isPoints: Bool) throws {
        if name.isEmpty || teacher.isEmpty { throw coursesError.courseEmpty }
        guard let _ = user else { throw authError.noUser }
        let newCourse = course(name: name, teacher: teacher, isPoints: isPoints)
        courses.append(newCourse)
        try? publishCourses()
    }
    
    func addCourseObject(_ newCourse: course) throws {
        guard let _ = user else { throw authError.noUser }
        courses.append(newCourse)
        try publishCourses()
    }
    
    func saveCourse(name: String, teacher: String, isPoints: Bool, ocourse: course) throws {
        if name.isEmpty || teacher.isEmpty { throw coursesError.courseEmpty }
        guard let _ = user else { throw authError.noUser }
        ocourse.name = name
        ocourse.teacher = teacher
        ocourse.isPoints = isPoints
        
        try coursesManager.shared.setCourse(data: ocourse)
    }
    
    func publishCourses() throws {
        if let _ = user {
            try coursesManager.shared.setCourses(data: courses)
        } else {
            throw authError.noUser
        }
    }
    
    func deleteAllCourses(_ coursess: [course]) throws {
        guard let _ = currentUser else { throw authError.noUser }
        
        for course in coursess {
            courses.remove(at: courses.firstIndex(of: course)!)
            try coursesManager.shared.removeCourse(data: course)
        }
    }
    
    func addSettingsListener() {
        settingsManager.shared.addSettingsListener { [weak self] settings in
            self?.userSettings = settings
            print("settings pulled")
        }
    }
}

enum coursesError: Error {
    case courseEmpty
    case noUserInFirebase
    case courseNotInFirebase
}

extension coursesError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .courseEmpty:
            return NSLocalizedString("The course is empty!", comment: "Courses Error")
        case .noUserInFirebase:
            return NSLocalizedString("Couldn't find a user in firebase. Contact mayanktiku04@gmail.com", comment: "Courses Error")
        case .courseNotInFirebase:
            return NSLocalizedString("Course not found in firebase.", comment: "Courses Error")
        }
    }
}
