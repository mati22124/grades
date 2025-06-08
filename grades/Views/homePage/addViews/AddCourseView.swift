//
//  AddCourseView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct addCourseView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: gradesViewModel
    
    @State private var courseName: String = ""
    @State private var courseTeacher: String = ""
    @State private var isPointsBased: Bool = false
    @State private var creditsString: String = ""
    @State private var markingPeriodString: String = ""
    @State private var yearString: String = ""
    @State private var courseLevel: CourseLevel? = nil
    @State private var isCore: Bool = false
    
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            GeometryReader { _ in
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Name")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Course Name", text: $courseName)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Course Teacher")
                                .font(.custom("ProductSans-Bold", size: 14))
                                .foregroundColor(.secCol.opacity(0.8))
                            
                            TextField("Course Teacher", text: $courseTeacher)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        // Course Level and Credits
                        HStack(spacing: 16) {
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Credits")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("e.g. 5.0", text: $creditsString)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        
                        // Marking Period and Year
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Marking Period")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("e.g. 1, 2, 3, 4", text: $markingPeriodString)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Year")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                TextField("e.g. 2024", text: $yearString)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Points-based Course")
                                    .font(.custom("ProductSans-Bold", size: 14))
                                    .foregroundColor(.secCol.opacity(0.8))
                                
                                Spacer()
                                
                                Toggle(isOn: $isPointsBased) {
                                    Text("")
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .terCol))
                            }
                            
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
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                    
                    Button(action: {
                        Task {
                            do {
                                isSubmitting = true
                                if courseName.isEmpty || courseTeacher.isEmpty {
                                    throw coursesError.courseEmpty
                                }
                                
                                let newCourse = course(name: courseName, teacher: courseTeacher, isPoints: isPointsBased, courseLevel: courseLevel, isCore: isCore)
                                newCourse.credits = Double(creditsString)
                                newCourse.markingPeriod = Int(markingPeriodString)
                                newCourse.year = Int(yearString)
                                
                                try viewModel.addCourseObject(newCourse)
                                dismiss()
                                isSubmitting = false
                            } catch coursesError.courseEmpty {
                                isSubmitting = false
                                errorMessage = "Please fill out all fields before adding the course."
                                showError = true
                            } catch {
                                isSubmitting = false
                                errorMessage = "An error occurred while adding the course: \(error.localizedDescription)"
                                showError = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isSubmitting ? "Adding..." : "Add Course")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isSubmitting ? Color.gray : Color.terCol)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(isSubmitting || courseName.isEmpty || courseTeacher.isEmpty)
                }
            }
        }
        .removeFocusOnTap()
        .navigationTitle("Add Course")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
        .alert("Error", isPresented: $showError, actions: {
            Button("OK") { showError = false }
        }, message: {
            Text(errorMessage ?? "An unknown error occurred")
        })
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        addCourseView()
            .environmentObject(gradesViewModel())
    }
}
