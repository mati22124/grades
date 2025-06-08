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

struct GPAScale: Codable {
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
    var f: Double
    
    static let defaultAPScale = GPAScale(
        aPlus: 5.0,
        a: 5.0,
        aMinus: 4.66,
        bPlus: 4.33,
        b: 4.0,
        bMinus: 3.66,
        cPlus: 3.33,
        c: 3.0,
        cMinus: 2.66,
        dPlus: 2.33,
        d: 2.0,
        dMinus: 1.66,
        f: 0.0
    )
    
    static let defaultHonorsScale = GPAScale(
        aPlus: 4.5,
        a: 4.5,
        aMinus: 4.16,
        bPlus: 3.83,
        b: 3.5,
        bMinus: 3.16,
        cPlus: 2.83,
        c: 2.5,
        cMinus: 2.16,
        dPlus: 1.83,
        d: 1.5,
        dMinus: 1.16,
        f: 0.0
    )
    
    static let defaultCPScale = GPAScale(
        aPlus: 4.0,
        a: 4.0,
        aMinus: 3.66,
        bPlus: 3.33,
        b: 3.0,
        bMinus: 2.66,
        cPlus: 2.33,
        c: 2.0,
        cMinus: 1.66,
        dPlus: 1.33,
        d: 1.0,
        dMinus: 0.66,
        f: 0.0
    )
}

struct GPAScales: Codable {
    var apScale: GPAScale
    var honorsScale: GPAScale
    var cpScale: GPAScale
    
    static let defaultScales = GPAScales(
        apScale: .defaultAPScale,
        honorsScale: .defaultHonorsScale,
        cpScale: .defaultCPScale
    )
}

struct UserSettings: Codable, Identifiable {
    let id: String
    var gradingScale: GradingScale
    var roundForLetterGrade: Bool
    var gpaScales: GPAScales
    
    init(id: String, gradingScale: GradingScale = .defaultScale, roundForLetterGrade: Bool = false, gpaScales: GPAScales = .defaultScales) {
        self.id = id
        self.gradingScale = gradingScale
        self.roundForLetterGrade = roundForLetterGrade
        self.gpaScales = gpaScales
    }
    
    static let defaultSettings = UserSettings(id: "default")
}
