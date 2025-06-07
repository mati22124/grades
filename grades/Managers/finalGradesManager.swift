//
//  finalGradesManager.swift
//  grades
//
//  Created by Mayank Tiku on 6/2/25.
//

import Foundation
import FirebaseFirestore

final class finalGradesManager {
    static let shared = finalGradesManager()
    
    private let db = Firestore.firestore()
    private let usercollection = Firestore.firestore().collection("users")
    
    var currentListener: (any ListenerRegistration)?
    
    func getFinalGrades(userId: String) async throws -> [finalGrade] {
        let documents = try await usercollection.document(userId).collection("finalGrades").getDocuments()
        var finalGrades: [finalGrade] = []
        
        for document in documents.documents {
            finalGrades.append(try document.data(as: finalGrade.self))
        }
        return finalGrades
    }
    
    func addFinalGradesListener(userId: String, completion: @escaping (_ finalGrades: [finalGrade]) -> Void) {
        currentListener = usercollection.document(userId).collection("finalGrades").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let finalGrades: [finalGrade] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: finalGrade.self)
            }
            completion(finalGrades)
        }
    }
    
    func removeListener() {
        if let listener = currentListener {
            listener.remove()
            print("removed finalGrades listener")
        } else {
            print("didn't remove listener")
        }
    }
    
    func removeFinalGrade(data: finalGrade) throws {
        let user = try authManager.shared.getAuthUser()
        usercollection.document(user.uid).collection("finalGrades").document(data.id).delete()
    }
    
    func setFinalGrades(data: [finalGrade]) throws {
        let user = try authManager.shared.getAuthUser()
        for finalGrade in data {
            try usercollection.document(user.uid).collection("finalGrades").document(finalGrade.id).setData(from: finalGrade)
        }
    }
    
    func setFinalGrade(data: finalGrade) throws {
        let user = try authManager.shared.getAuthUser()
        try usercollection.document(user.uid).collection("finalGrades").document(data.id).setData(from: data)
    }
    
    func addFinalGrade(data: finalGrade) throws {
        let user = try authManager.shared.getAuthUser()
        try usercollection.document(user.uid).collection("finalGrades").document(data.id).setData(from: data)
    }
}