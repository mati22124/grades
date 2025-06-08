//
//  editFinalGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 6/7/25.
//

import SwiftUI

struct editFinalGradeView: View {
    
    let originalFinalGrade: finalGrade
    
    @State private var name: String = ""
    @State private var teacher: String = ""
    @State private var letterGrade: String = "A+"
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var markingPeriod: Int? = nil
    @State private var credits: Double = 5.0
    @State private var courseLevel: CourseLevel? = nil
    @State private var isCore: Bool = false
    @State private var isPressed = false
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var finalGradesVM = finalGradesViewModel()
    
    let letterGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    
    var isValidInput: Bool {
        !name.isEmpty && !teacher.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        // Course Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Name")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Enter course name", text: $name)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                        }
                        
                        // Teacher
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Teacher")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Enter teacher name", text: $teacher)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                        }
                        
                        // Final Grade and Course Level
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Final Grade")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                HStack {
                                    Picker("Letter Grade", selection: $letterGrade) {
                                        ForEach(letterGrades, id: \.self) { grade in
                                            Text(grade).tag(grade)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(.terCol)
                                    .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Course Level")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                HStack {
                                    Picker("Course Level", selection: $courseLevel) {
                                        Text("None").tag(nil as CourseLevel?)
                                        ForEach(CourseLevel.allCases, id: \.self) { level in
                                            Text(level.displayName).tag(level as CourseLevel?)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(.terCol)
                                    .frame(maxWidth: .infinity)
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        
                        // Year and Marking Period
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Academic Year")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("Year", value: $year, format: .number.grouping(.never))
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Marking Period")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                HStack {
                                    TextField("Leave blank for full year", value: $markingPeriod, format: .number)
                                        .font(.custom("ProductSans-Regular", size: 16))
                                        .foregroundColor(.white)
                                        .keyboardType(.numberPad)
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        
                        // Credits
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Credits")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Credits", value: $credits, format: .number)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                        }
                        
                        // Core Class Toggle
                        HStack {
                            Text("Core Class")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            Spacer()
                            
                            Toggle(isOn: $isCore) {
                                Text("")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .terCol))
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        name = originalFinalGrade.name
                        teacher = originalFinalGrade.teacher
                        letterGrade = originalFinalGrade.letterGrade
                        year = originalFinalGrade.year
                        markingPeriod = originalFinalGrade.markingPeriod
                        credits = originalFinalGrade.credits
                        courseLevel = originalFinalGrade.courseLevel
                        isCore = originalFinalGrade.isCore ?? false
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Save Button
                    Button(action: {
                        updateFinalGrade()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isPressed ? "Saving..." : "Save Changes")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isValidInput ? Color.terCol : Color.gray)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(!isValidInput || isPressed)
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .removeFocusOnTap()
        .navigationTitle("Edit Final Grade")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
    
    private func updateFinalGrade() {
        do {
            isPressed = true
            var updatedFinalGrade = originalFinalGrade
            updatedFinalGrade.name = name
            updatedFinalGrade.teacher = teacher
            updatedFinalGrade.letterGrade = letterGrade
            updatedFinalGrade.year = year
            updatedFinalGrade.markingPeriod = markingPeriod
            updatedFinalGrade.credits = credits
            updatedFinalGrade.courseLevel = courseLevel
            updatedFinalGrade.isCore = isCore
            
            try finalGradesVM.updateFinalGrade(updatedFinalGrade)
            dismiss()
            isPressed = false
        } catch {
            isPressed = false
            print("Error updating final grade: \(error)")
        }
    }
}

#Preview {
    NavigationView {
        editFinalGradeView(originalFinalGrade: finalGrade(
            name: "Test Course",
            teacher: "Test Teacher",
            letterGrade: "A+",
            year: 2024,
            markingPeriod: 1,
            credits: 5.0
        ))
    }
}