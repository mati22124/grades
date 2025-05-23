//
//  userModel.swift
//  grades
//
//  Created by Mayank Tiku on 10/2/24.
//

import Foundation

struct DBUser: Codable {
    var uid: String
    var name: String
    var email: String
}

struct GradingScale: Codable {
    var aPlus: Double
    var a: Double
    var aMinus: Double
    var bPlus: Double
    var b: Double
    var bMinus: Double
    var cPlus: Double
    var c: Double
    var cMinus: Double
    var dPlus: Double
    var d: Double
    var dMinus: Double
    
    static let defaultScale = GradingScale(
        aPlus: 97,
        a: 93,
        aMinus: 90,
        bPlus: 87,
        b: 83,
        bMinus: 80,
        cPlus: 77,
        c: 73,
        cMinus: 70,
        dPlus: 67,
        d: 63,
        dMinus: 60
    )
}

struct UserSettings: Codable, Identifiable {
    let id: String
    var gradingScale: GradingScale
    var roundForLetterGrade: Bool
    
    init(id: String, gradingScale: GradingScale = .defaultScale, roundForLetterGrade: Bool = false) {
        self.id = id
        self.gradingScale = gradingScale
        self.roundForLetterGrade = roundForLetterGrade
    }
    
    static let defaultSettings = UserSettings(id: "default")
}
