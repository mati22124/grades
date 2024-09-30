//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct ClassGrade: Identifiable {
    let id = UUID()
    let name: String
    let grade: String
}

struct StudentClassesView: View {
    let backgroundColor = Color(red: 0.2, green: 0.5, blue: 0.8) // Darker sky blue
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Gold accent
    
    let classes = [
        ClassGrade(name: "Mathematics", grade: "A"),
        ClassGrade(name: "Science", grade: "B+"),
        ClassGrade(name: "Literature", grade: "A-"),
        ClassGrade(name: "History", grade: "B"),
        ClassGrade(name: "Physical Education", grade: "A"),
        ClassGrade(name: "Art", grade: "A+")
    ]
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(classes) { classGrade in
                            ClassGradeRow(classGrade: classGrade)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct ClassGradeRow: View {
    let classGrade: ClassGrade
    
    var body: some View {
        HStack {
            Text(classGrade.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            Spacer()
            
            Text(classGrade.grade)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct StudentClassesView_Previews: PreviewProvider {
    static var previews: some View {
        StudentClassesView()
    }
}
