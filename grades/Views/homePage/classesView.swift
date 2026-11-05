//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct classesView: View {
    @Binding var showSignInView: Bool
    
    @EnvironmentObject var viewModel: gradesViewModel
    @StateObject private var finalGradesVM = finalGradesViewModel()
    
    @State private var didAppear: Bool = false
    @State private var menuIsPresentedCourse: Bool = false
    @State private var showingAlert: Bool = false
    
    @State private var courseToDelete: course? = nil
    @State private var finalGradeToDelete: finalGrade? = nil
    @State private var showingFinalGradeAlert: Bool = false
    @State private var selectedMarkingPeriod: Int? = nil
    @State private var selectedYear: Int? = nil
    
    // Get unique marking periods from courses and final grades
    var availableMarkingPeriods: [Int] {
        let coursePeriods = viewModel.courses.compactMap { $0.markingPeriod }
        let finalGradePeriods = finalGradesVM.finalGrades.compactMap { $0.markingPeriod }
        return Array(Set(coursePeriods + finalGradePeriods)).sorted()
    }
    
    // Get unique years from courses and final grades
    var availableYears: [Int] {
        let courseYears = viewModel.courses.compactMap { $0.year }
        let finalGradeYears = finalGradesVM.finalGrades.map { $0.year }
        return Array(Set(courseYears + finalGradeYears)).sorted()
    }
    
    // Filter courses based on selected marking period and year
    var filteredCourses: [course] {
        viewModel.courses.filter { course in
            let matchesMP = selectedMarkingPeriod == nil || course.markingPeriod == selectedMarkingPeriod
            let matchesYear = selectedYear == nil || course.year == selectedYear
            return matchesMP && matchesYear
        }
    }
    
    // Filter final grades based on selected marking period and year
    var filteredFinalGrades: [finalGrade] {
        finalGradesVM.finalGrades.filter { finalGrade in
            let matchesMP = selectedMarkingPeriod == nil || finalGrade.markingPeriod == selectedMarkingPeriod
            let matchesYear = selectedYear == nil || finalGrade.year == selectedYear
            return matchesMP && matchesYear
        }
    }
    
    // Group courses and final grades by year and marking period
    var groupedItems: [(key: String, year: Int, markingPeriod: Int, courses: [course], finalGrades: [finalGrade])] {
        // Get all unique year-mp combinations from both courses and final grades
        var allKeys = Set<String>()
        
        filteredCourses.forEach { course in
            allKeys.insert("\(course.year ?? 0)-\(course.markingPeriod ?? 0)")
        }
        
        filteredFinalGrades.forEach { finalGrade in
            if let mp = finalGrade.markingPeriod {
                allKeys.insert("\(finalGrade.year)-\(mp)")
            } else {
                allKeys.insert("\(finalGrade.year)-0")
            }
        }
        
        // Group courses and final grades by their keys
        let groupedCourses = Dictionary(grouping: filteredCourses) { course in
            "\(course.year ?? 0)-\(course.markingPeriod ?? 0)"
        }
        
        let groupedFinalGrades = Dictionary(grouping: filteredFinalGrades) { finalGrade in
            if let mp = finalGrade.markingPeriod {
                return "\(finalGrade.year)-\(mp)"
            } else {
                return "\(finalGrade.year)-0" // Use 0 for academic year only
            }
        }
        
        // Create combined groups
        return allKeys.map { key in
            let components = key.split(separator: "-")
            let year = Int(components[0]) ?? 0
            let mp = Int(components[1]) ?? 0
            return (
                key: key,
                year: year,
                markingPeriod: mp,
                courses: groupedCourses[key] ?? [],
                finalGrades: groupedFinalGrades[key] ?? []
            )
        }
        .sorted { lhs, rhs in
            if lhs.year != rhs.year {
                return lhs.year > rhs.year // Higher years first
            } else {
                // Within same year: MP 0 (full year) first, then MP 1, 2, 3, etc.
                if lhs.markingPeriod == 0 {
                    return true
                } else if rhs.markingPeriod == 0 {
                    return false
                } else {
                    return lhs.markingPeriod > rhs.markingPeriod
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 12) {
                        if (filteredCourses.isEmpty && filteredFinalGrades.isEmpty) {
                            Text("No Courses")
                                .foregroundStyle(.secCol)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.custom("ProductSans-Regular", size: 25))
                        }
                        ForEach(groupedItems, id: \.key) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                // Section header
                                HStack {
                                    Text(String(group.year)+"-"+String(group.year+1))
                                        .font(.custom("ProductSans-Bold", size: 20))
                                        .foregroundColor(.secCol)
                                    if group.markingPeriod != 0 {
                                        Text("MP \(group.markingPeriod)")
                                            .font(.custom("ProductSans-Regular", size: 18))
                                            .foregroundColor(.secCol.opacity(0.8))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top, group.key == groupedItems.first?.key ? 0 : 10)
                                
                                // Regular courses in this group
                                ForEach(group.courses) { course in
                                    let index = viewModel.courses.firstIndex(where: { $0.id == course.id })!
                                    NavigationLink {
                                        CourseDetailView(course: $viewModel.courses[index])
                                            .environmentObject(viewModel)
                                    } label: {
                                        SwipeToDeleteView(content: {
                                            ClassGradeBlock(classGrade: $viewModel.courses[index])
                                                .environmentObject(viewModel)
                                        }, onDelete: {
                                            courseToDelete = viewModel.courses[index]
                                        }, onEdit: editCourseView(originalCourse: $viewModel.courses[index]).environmentObject(viewModel))
                                    }
                                }
                                
                                // Final grades in this group
                                ForEach(group.finalGrades) { finalGrade in
                                    SwipeToDeleteView(content: {
                                        FinalGradeBlock(finalGrade: finalGrade)
                                    }, onDelete: {
                                        finalGradeToDelete = finalGrade
                                        showingFinalGradeAlert = true
                                    }, onEdit: editFinalGradeView(originalFinalGrade: finalGrade))
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                }
                .background(.clear)
                .onChange(of: courseToDelete, { _, newValue in
                    if let _ = courseToDelete {
                        showingAlert = true
                    }
                })
                .alert("Confirm delete", isPresented: $showingAlert) {
                    Button("Delete", role: .destructive) {
                        try? coursesManager.shared.removeCourse(data: courseToDelete!)
                        courseToDelete = nil
                    }
                    Button("Cancel", role: .cancel) {
                        courseToDelete = nil
                    }
                } message: {
                    Text("Are you sure you want to delete \(courseToDelete?.name ?? "NOT WORKING DONT DELETE")?")
                }
                .alert("Delete All Courses", isPresented: $viewModel.showDeleteAllConfirmation) {
                    Button("Delete All", role: .destructive) {
                        do {
                            try viewModel.deleteAllCourses(filteredCourses)
                            selectedYear = nil
                            selectedMarkingPeriod = nil
                        } catch {
                            print("Error deleting all courses: \(error)")
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete all \(filteredCourses.count) courses? This action cannot be undone.")
                }
                .alert("Confirm delete final grade", isPresented: $showingFinalGradeAlert) {
                    Button("Delete", role: .destructive) {
                        if let finalGrade = finalGradeToDelete {
                            try? finalGradesVM.removeFinalGrade(finalGrade)
                            finalGradeToDelete = nil
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        finalGradeToDelete = nil
                    }
                } message: {
                    Text("Are you sure you want to delete \(finalGradeToDelete?.name ?? "this final grade")?")
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.keyboard)
                
                menuButtonAdd(isMenuPresented: $menuIsPresentedCourse, menuItems: [
                    menuItem(destination: addCourseView().environmentObject(viewModel), optionName: "Add Course", icon: "plus.circle.fill"),
                    menuItem(destination: AddFinalGradeView(), optionName: "Add Final Grade", icon: "graduationcap.fill"),
                    menuItem(action: {
                        viewModel.showDeleteAllConfirmation = true
                    }, optionName: "Delete All", icon: "trash.fill")
                    //                ,
                    //                menuItem(destination: importView(), optionName: "Import", icon: "square.and.arrow.up")
                ]
                )
            }
            .onAppear(perform: {
                if !didAppear {
                    Task {
                        do {
                            try await viewModel.loadCurrentUser()
                            await finalGradesVM.loadFinalGrades()
                            didAppear = true
                        } catch {
                            print("error: \(error)")
                        }
                    }
                }
            })
            .onChange(of: showSignInView, { _, newValue in
                if !didAppear && !newValue {
                    Task {
                        do {
                            try await viewModel.loadCurrentUser()
                            await finalGradesVM.loadFinalGrades()
                            didAppear = true
                        } catch {
                            print("error: \(error)")
                        }
                    }
                } else if newValue {
                    didAppear = false
                    viewModel.courses = []
                    finalGradesVM.finalGrades = []
                }
            })
            .navigationTitle("Courses")
            .navigationBarTitleTextColor(.secCol)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CourseFilterMenu(
                        availableMarkingPeriods: availableMarkingPeriods,
                        availableYears: availableYears,
                        selectedMarkingPeriod: $selectedMarkingPeriod,
                        selectedYear: $selectedYear
                    )
                }
            }
        }
    }
}

struct ClassGradeBlock: View {
    @Binding var classGrade: course
    @EnvironmentObject var viewModel: gradesViewModel
    
    private func buildCourseDetailsString(credits: Double?, isCore: Bool?, level: CourseLevel?) -> String {
        var details: [String] = []
        
        if let credits = credits {
            details.append("\(String(format: "%.1f", credits)) credits")
        }
        
        if isCore == true {
            details.append("Core")
        }
        
        if let level = level {
            details.append(level.displayName)
        }
        
        return details.joined(separator: " - ")
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text(classGrade.name)
                    .font(.custom("ProductSans-Bold", size: 22))
                    .foregroundColor(.secCol)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if classGrade.teacher != "" {
                    Text(classGrade.teacher)
                        .font(.custom("ProductSans-Regular", size: 13))
                        .foregroundColor(.secCol)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Course details
                let courseDetails = buildCourseDetailsString(credits: classGrade.credits, isCore: classGrade.isCore, level: classGrade.courseLevel)
                if !courseDetails.isEmpty {
                    Text(courseDetails)
                        .font(.custom("ProductSans-Regular", size: 12))
                        .foregroundColor(.secCol.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
            VStack {
                Text(classGrade.average.averageToGrade(settings: viewModel.userSettings))
                    .font(.custom("ProductSans-Bold", size: 30))
                    .foregroundColor(.secCol)
                Text("\(classGrade.average.roundedGrade())%")
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.secCol)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.terCol) //Color.accentRed.brightness(-0.08)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding()
        .background(Color.black.opacity(0.3)) //Color.bgBlue.opacity(0.75)
        .cornerRadius(16)
    }
}

struct CourseFilterMenu: View {
    let availableMarkingPeriods: [Int]
    let availableYears: [Int]
    @Binding var selectedMarkingPeriod: Int?
    @Binding var selectedYear: Int?
    
    var body: some View {
        Menu {
            Section("Marking Period") {
                Button {
                    selectedMarkingPeriod = nil
                } label: {
                    HStack {
                        Text("All")
                        Spacer()
                        if selectedMarkingPeriod == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                ForEach(availableMarkingPeriods, id: \.self) { period in
                    Button {
                        selectedMarkingPeriod = period
                    } label: {
                        HStack {
                            Text("MP \(period)")
                            Spacer()
                            if selectedMarkingPeriod == period {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Section("Academic Year") {
                Button {
                    selectedYear = nil
                } label: {
                    HStack {
                        Text("All")
                        Spacer()
                        if selectedYear == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                ForEach(availableYears, id: \.self) { year in
                    Button {
                        selectedYear = year
                    } label: {
                        HStack {
                            Text(String(year)+"-"+String(year+1))
                            Spacer()
                            if selectedYear == year {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.terCol)
                .font(.system(size: 18))
        }
    }
}

struct FinalGradeBlock: View {
    let finalGrade: finalGrade
    
    private func buildCourseDetailsString(credits: Double?, isCore: Bool?, level: CourseLevel?) -> String {
        var details: [String] = []
        
        if let credits = credits {
            details.append("\(String(format: "%.1f", credits)) credits")
        }
        
        if isCore == true {
            details.append("Core")
        }
        
        if let level = level {
            details.append(level.displayName)
        }
        
        return details.joined(separator: " - ")
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text(finalGrade.name)
                    .font(.custom("ProductSans-Bold", size: 22))
                    .foregroundColor(.secCol)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if finalGrade.teacher != "" {
                    Text(finalGrade.teacher)
                        .font(.custom("ProductSans-Regular", size: 13))
                        .foregroundColor(.secCol)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Course details
                let courseDetails = buildCourseDetailsString(credits: finalGrade.credits, isCore: finalGrade.isCore, level: finalGrade.courseLevel)
                if !courseDetails.isEmpty {
                    Text(courseDetails)
                        .font(.custom("ProductSans-Regular", size: 12))
                        .foregroundColor(.secCol.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
            Text(finalGrade.letterGrade)
                .font(.custom("ProductSans-Bold", size: 30))
                .foregroundColor(.secCol)
        
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.terCol)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    classesView(showSignInView: .constant(false))
        .environmentObject(gradesViewModel())
}

