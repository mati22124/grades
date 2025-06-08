//
//  settingsManager.swift
//  grades
//
//  Created by Mayank Tiku on 5/22/25.
//

import Foundation
import FirebaseFirestore

final class settingsManager {
    static let shared = settingsManager()
    
    private let db = Firestore.firestore()
    private let usercollection = Firestore.firestore().collection("users")
    
    var currentListener: (any ListenerRegistration)?
    
    private init() {}
    
    func getUserSettings() async throws -> UserSettings {
        let authUser = try authManager.shared.getAuthUser()
        
        do {
            let document = try await usercollection.document(authUser.uid).collection("settings").document("preferences").getDocument()
            
            if document.exists {
                return try document.data(as: UserSettings.self)
            } else {
                // Return default settings if none exist
                return UserSettings(id: authUser.uid)
            }
        } catch {
            print("Error getting user settings: \(error)")
            // Return default settings on error
            return UserSettings(id: authUser.uid)
        }
    }
    
    func setUserSettings(settings: UserSettings) async throws {
        let authUser = try authManager.shared.getAuthUser()
        try usercollection.document(authUser.uid).collection("settings").document("preferences").setData(from: settings)
    }
    
    func updateGradingScale(gradingScale: GradingScale) async throws {
        let authUser = try authManager.shared.getAuthUser()
        let settingsRef = usercollection.document(authUser.uid).collection("settings").document("preferences")
        
        try await settingsRef.updateData([
            "gradingScale": try Firestore.Encoder().encode(gradingScale)
        ])
    }
    
    func updateRoundingPreference(roundForLetterGrade: Bool) async throws {
        let authUser = try authManager.shared.getAuthUser()
        let settingsRef = usercollection.document(authUser.uid).collection("settings").document("preferences")
        
        try await settingsRef.updateData([
            "roundForLetterGrade": roundForLetterGrade
        ])
    }
    
    func addSettingsListener(completion: @escaping (_ settings: UserSettings?) -> Void) {
        do {
            let authUser = try authManager.shared.getAuthUser()
            
            currentListener = usercollection.document(authUser.uid).collection("settings").document("preferences").addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching settings: \(error?.localizedDescription ?? "Unknown error")")
                    completion(UserSettings(id: authUser.uid))
                    return
                }
                
                if document.exists {
                    do {
                        let settings = try document.data(as: UserSettings.self)
                        completion(settings)
                    } catch {
                        print("Error decoding settings: \(error)")
                        completion(UserSettings(id: authUser.uid))
                    }
                } else {
                    // Document doesn't exist, return default settings
                    completion(UserSettings(id: authUser.uid))
                }
            }
        } catch {
            print("Error setting up settings listener: \(error)")
            completion(nil)
        }
    }
    
    func removeListener() {
        if let listener = currentListener {
            listener.remove()
            print("removed settings listener")
        } else {
            print("didnt remove settings listener")
        }
    }
}
