//
//  userManager.swift
//  grades
//
//  Created by Mayank Tiku on 10/7/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class userManager {
    static let shared = userManager()
    
    private let db = Firestore.firestore()
    private let usercollection = Firestore.firestore().collection("users")

    
    func getUser(userId: String) async throws -> DBUser {
        try await usercollection.document(userId).getDocument(as: DBUser.self)
    }
    
    func setUser(data: DBUser) throws {
        try usercollection.document(data.uid).setData(from: data)
    }
}
