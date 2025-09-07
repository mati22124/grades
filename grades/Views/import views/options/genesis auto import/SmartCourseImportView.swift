//
//  SmartCourseImportView.swift
//  grades
//
//  Created by Mayank Tiku on 9/6/25.
//

import SwiftUI

struct SmartCourseImportView: View {
    @Binding var coursesToImport: [course]
    
    @EnvironmentObject var gradesVm: gradesViewModel
    @Environment(\.dismiss) private var dismiss
    
    // For new courses configuration
    @State private var year: String = ""
    @State private var credits: String = ""
    @State private var courseLevels: [String: CourseLevel?] = [:]
    @State private var isCoreCourses: [String: Bool] = [:]
    
    // Track which courses are new vs updates
    @State private var coursesToMerge: [(existing: course, imported: course, gradeDifference: [grade])] = []
    @State private var newCourses: [course] = []
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isProcessing: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Show courses to be merged
                    if !coursesToMerge.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Courses to Update")
                                .font(.custom("ProductSans-Bold", size: 18))
                                .foregroundColor(.secCol)
                            
                            Text("\(coursesToMerge.count) existing courses will receive new grades")
                                .font(.custom("ProductSans-Regular", size: 14))
                                .foregroundColor(.green)
                            
                            ForEach(coursesToMerge, id: \.existing.id) { pair in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pair.existing.name)
                                            .font(.custom("ProductSans-Bold", size: 16))
                                            .foregroundColor(.secCol)
                                        Text("Adding \(pair.gradeDifference.count) new grades")
                                            .font(.custom("ProductSans-Regular", size: 14))
                                            .foregroundColor(.secCol.opacity(0.7))
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.triangle.merge")
                                        .foregroundColor(.green)
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    // Configuration for new courses
                    if !newCourses.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Enter details for \(newCourses.count) new courses")
                                .font(.custom("ProductSans-Bold", size: 16))
                                .foregroundColor(.secCol)
                                .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Common settings fields
                        VStack(spacing: 16) {
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
                                
                                TextField("e.g. 5.0", text: $credits)
                                    .font(.custom("ProductSans-Regular", size: 16))
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .background(Color.secCol.opacity(0.2))
                            .padding(.horizontal)
                        
                        Text("Set course level for each course")
                            .font(.custom("ProductSans-Bold", size: 16))
                            .foregroundColor(.secCol.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // Individual course settings
                        VStack(spacing: 20) {
                            ForEach(newCourses, id: \.id) { course in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(course.name)
                                        .font(.custom("ProductSans-Bold", size: 16))
                                        .foregroundColor(.secCol)
                                    
                                    if !course.teacher.isEmpty {
                                        Text(course.teacher)
                                            .font(.custom("ProductSans-Regular", size: 14))
                                            .foregroundColor(.secCol.opacity(0.7))
                                    }
                                    
                                    // Course level selector
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Course Level")
                                            .font(.custom("ProductSans-Regular", size: 14))
                                            .foregroundColor(.secCol.opacity(0.8))
                                        
                                        HStack(spacing: 0) {
                                            ForEach([CourseLevel.CP, CourseLevel.honors, CourseLevel.AP], id: \.self) { level in
                                                Button {
                                                    courseLevels[course.id] = level
                                                } label: {
                                                    Text(level.displayName)
                                                        .font(.custom("ProductSans-Bold", size: 14))
                                                        .foregroundColor(courseLevels[course.id] == level ? .primaryCol : .white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 12)
                                                        .background(
                                                            courseLevels[course.id] == level ? Color.terCol : Color.black.opacity(0.3)
                                                        )
                                                }
                                            }
                                        }
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.secCol.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                    
                                    // Core Class Toggle
                                    HStack {
                                        Text("Core Class")
                                            .font(.custom("ProductSans-Regular", size: 14))
                                            .foregroundColor(.secCol.opacity(0.8))
                                        
                                        Spacer()
                                        
                                        Toggle(isOn: Binding(
                                            get: { isCoreCourses[course.id] ?? false },
                                            set: { isCoreCourses[course.id] = $0 }
                                        )) {
                                            Text("")
                                        }
                                        .toggleStyle(SwitchToggleStyle(tint: .terCol))
                                    }
                                    .padding(.top, 8)
                                }
                                .padding()
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Import button
                    Button(action: {
                        performImport()
                    }) {
                        HStack {
                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Import Courses")
                                    .font(.custom("ProductSans-Bold", size: 16))
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isValidInput ? Color.terCol : Color.gray)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .disabled(!isValidInput || isProcessing)
                }
            }
        }
        .navigationTitle("Import Courses")
        .navigationBarTitleTextColor(.secCol)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            analyzeCourses()
            // Set default values for new courses
            for course in newCourses {
                if courseLevels[course.id] == nil {
                    if course.name.dropFirst(2).uppercased() == "AP" {
                        courseLevels[course.id] = .AP
                    } else {
                        courseLevels[course.id] = .CP
                    }
                }
                if isCoreCourses[course.id] == nil {
                    isCoreCourses[course.id] = false
                }
            }
        }
        .alert("Import Complete", isPresented: $showAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isValidInput: Bool {
        // For merging existing courses, no input needed
        if !coursesToMerge.isEmpty && newCourses.isEmpty {
            return true
        }
        // For new courses, need marking period and year
        if !newCourses.isEmpty {
            return Int(year) != nil
        }
        return false
    }
    
    private func analyzeCourses() {
        coursesToMerge.removeAll()
        newCourses.removeAll()
        
        for importedCourse in coursesToImport {
            // Check if course with same name and marking period exists
            if let existingCourse = gradesVm.courses.first(where: { existing in
                existing.name.lowercased() == importedCourse.name.lowercased() &&
                existing.markingPeriod == importedCourse.markingPeriod
            }) {
                // This course exists - prepare to merge grades
                // Get existing grade names to avoid duplicates
                let existingGradeNames = Set(existingCourse.grades.map { $0.name.lowercased() })
                var gradesToAdd: [grade] = []
                
                // Add only new grades (grades with different names)
                for grade in importedCourse.grades {
                    if !existingGradeNames.contains(grade.name.lowercased()) {
                        gradesToAdd.append(grade)
                    }
                }
                
                coursesToMerge.append((existing: existingCourse, imported: importedCourse, gradeDifference: gradesToAdd))
            } else {
                // This is a new course
                newCourses.append(importedCourse)
            }
        }
    }
    
    private func performImport() {
        isProcessing = true
        
        Task {
            do {
                var updatedCount = 0
                var addedCount = 0
                
                // Add new courses with configuration
                if !newCourses.isEmpty {
                    guard let yr = Int(year) else {
                        alertMessage = "Invalid year"
                        showAlert = true
                        isProcessing = false
                        return
                    }
                    
                    let courseCredits = Double(credits)
                    
                    for newCourse in newCourses {
                        newCourse.year = yr
                        newCourse.credits = courseCredits
                        newCourse.courseLevel = courseLevels[newCourse.id] ?? .CP
                        newCourse.isCore = isCoreCourses[newCourse.id] ?? false
                        
                        gradesVm.courses.append(newCourse)
                        addedCount += 1
                    }
                }
                
                // Merge grades into existing courses
                for (existingCourse, _, gradesToAdd) in coursesToMerge {
                    if existingCourse.isPoints {
                        existingCourse.grades.append(contentsOf: gradesToAdd)
                    } else {
                        for grade in gradesToAdd {
                            if let categoryName = grade.category,
                               let idx = existingCourse.categories.firstIndex(where: { $0.name.lowercased() == categoryName.lowercased() }) {
                                existingCourse.categories[idx].grades.append(grade)
                            }
                            // Optionally, handle grades with no matching category or no category name
                        }
                    }
                    updatedCount += 1
                }
                
                // Save all changes
                try gradesVm.publishCourses()
                
                // Clear imported courses
                coursesToImport.removeAll()
                
                // Show success message
                if updatedCount > 0 && addedCount > 0 {
                    alertMessage = "Successfully updated \(updatedCount) courses and added \(addedCount) new courses!"
                } else if updatedCount > 0 {
                    alertMessage = "Successfully updated \(updatedCount) courses!"
                } else {
                    alertMessage = "Successfully added \(addedCount) new courses!"
                }
                showAlert = true
                isProcessing = false
                
            } catch {
                alertMessage = "Error importing courses: \(error.localizedDescription)"
                showAlert = true
                isProcessing = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        SmartCourseImportView(coursesToImport: .constant([]))
            .environmentObject(gradesViewModel())
    }
}
