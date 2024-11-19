//
//  coursesManager.swift
//  grades
//
//  Created by Mayank Tiku on 10/26/24.
//

import Foundation
import FirebaseFirestore

final class coursesManager {
    static let shared = coursesManager()
    
    private let db = Firestore.firestore()
    private let usercollection = Firestore.firestore().collection("users")

    
    func getCourses(userId: String) async throws -> [course] {
        let x = try await usercollection.document(userId).collection("courses").getDocuments()
        var y: [course] = []
        
        for i in x.documents {
            y.append(try i.data(as: course.self))
        }
        return y
    }
    
    func addCoursesListener(userId: String, completion: @escaping (_ courses: [course]) -> Void)  {
        usercollection.document(userId).collection("courses").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let courses: [course] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: course.self)
            }
            completion(courses)
        }
    }
    
    func removeCourse(data: course) throws {
        let x = try authManager.shared.getAuthUser()
        usercollection.document(x.uid).collection("courses").document(data.id).delete()
    }
    
    func setCourses(data: [course]) throws {
        let x = try authManager.shared.getAuthUser()
        for i in data {
            try usercollection.document(x.uid).collection("courses").document(i.id).setData(from: i)
        }
    }
    
    func setCourse(data: course) throws {
        let x = try authManager.shared.getAuthUser()
        
        try usercollection.document(x.uid).collection("courses").document(data.id).setData(from: data)
    }
}
