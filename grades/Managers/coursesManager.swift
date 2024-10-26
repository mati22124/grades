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
    
    func setCourses(uid: String, data: [course]) throws {
        for i in data {
            try usercollection.document(uid).collection("courses").document(i.id).setData(from: i)
        }
    }
}
