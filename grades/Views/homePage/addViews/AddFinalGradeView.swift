//
//  AddFinalGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 6/2/25.
//

import SwiftUI

struct AddFinalGradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var finalGradesVM = finalGradesViewModel()
    
    @State private var name: String = ""
    @State private var teacher: String = ""
    @State private var letterGrade: String = "A+"
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var markingPeriod: Int? = nil
    @State private var credits: Double = 5.0
    @State private var isPressed = false
    
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
                        
                        // Final Grade
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
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                    
                    // Save Button
                    Button(action: {
                        addFinalGrade()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isPressed ? "Adding..." : "Add Final Grade")
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
        .navigationTitle("Add Final Grade")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
    
    private func addFinalGrade() {
        do {
            isPressed = true
            try finalGradesVM.addFinalGrade(
                name: name,
                teacher: teacher,
                letterGrade: letterGrade,
                year: year,
                markingPeriod: markingPeriod,
                credits: credits
            )
            dismiss()
            isPressed = false
        } catch {
            isPressed = false
            print("Error adding final grade: \(error)")
        }
    }
}

#Preview {
    AddFinalGradeView()
}
