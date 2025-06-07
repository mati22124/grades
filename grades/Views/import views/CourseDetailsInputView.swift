//
//  CourseDetailsInputView.swift
//  grades
//
//  Created by Mayank Tiku on 1/25/25.
//

import SwiftUI

struct CourseDetailsInputView: View {
    @Binding var courses: [course]
    @State private var markingPeriod: String = ""
    @State private var year: String = ""
    @State private var credits: String = ""
    @State private var teacherNames: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enter the marking period number (1-4), course start year, and credits")
                            .font(.custom("ProductSans-Bold", size: 16))
                            .foregroundColor(.secCol)
                            .padding(.bottom, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Marking Period")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("e.g. 1, 2, 3, 4", text: $markingPeriod)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Year")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("e.g. 2024", text: $year)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Credits")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("e.g. 1.0", text: $credits)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .keyboardType(.decimalPad)
                            
                            Text("Note: Individual course credits can be edited later for science courses with more credits")
                                .font(.custom("ProductSans-Regular", size: 12))
                                .foregroundColor(.secCol.opacity(0.6))
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color.secCol.opacity(0.2))
                        .padding(.horizontal)
                    
                    Text("Enter teacher names for each course")
                        .font(.custom("ProductSans-Bold", size: 16))
                        .foregroundColor(.secCol.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(courses) { course in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(course.name)
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol)
                                
                                TextField("Teacher name", text: Binding(
                                    get: { teacherNames[course.id] ?? "" },
                                    set: { teacherNames[course.id] = $0 }
                                ))
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        updateCoursesAndComplete()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Continue")
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
                    .disabled(!isValidInput)
                }
            }
        }
        .removeFocusOnTap()
        .navigationTitle("Course Information")
        .navigationBarTitleTextColor(.secCol)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isValidInput: Bool {
        Int(markingPeriod) != nil && Int(year) != nil
    }
    
    private func updateCoursesAndComplete() {
        guard let mp = Int(markingPeriod), let yr = Int(year) else { return }
        
        let courseCredits = Double(credits)
        
        for index in courses.indices {
            courses[index].markingPeriod = mp
            courses[index].year = yr
            courses[index].credits = courseCredits
            if let teacherName = teacherNames[courses[index].id], !teacherName.isEmpty {
                courses[index].teacher = teacherName
            }
        }
        
        onComplete()
    }
}
