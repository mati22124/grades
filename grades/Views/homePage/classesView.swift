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
    
    @State private var didAppear: Bool = false
    @State private var menuIsPresentedCourse: Bool = false
    @State private var showingAlert: Bool = false
    
    @State private var courseToDelete: course? = nil
    @State private var selectedMarkingPeriod: Int? = nil
    @State private var selectedYear: Int? = nil
    
    // Get unique marking periods from courses
    var availableMarkingPeriods: [Int] {
        let periods = viewModel.courses.compactMap { $0.markingPeriod }
        return Array(Set(periods)).sorted()
    }
    
    // Get unique years from courses
    var availableYears: [Int] {
        let years = viewModel.courses.compactMap { $0.year }
        return Array(Set(years)).sorted()
    }
    
    // Filter courses based on selected marking period and year
    var filteredCourses: [course] {
        viewModel.courses.filter { course in
            let matchesMP = selectedMarkingPeriod == nil || course.markingPeriod == selectedMarkingPeriod
            let matchesYear = selectedYear == nil || course.year == selectedYear
            return matchesMP && matchesYear
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    ScrollView {
                        VStack(spacing: 12) {
                            if (filteredCourses.isEmpty) {
                                Text("No Courses")
                                    .tint(.secCol)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.custom("ProductSans-Regular", size: 25))
                            }
                            ForEach(filteredCourses) { course in
                                let index = viewModel.courses.firstIndex(where: { $0.id == course.id })!
                                NavigationLink {
                                    CourseDetailView(course: $viewModel.courses[index])
                                } label: {
                                    SwipeToDeleteView(content: {
                                        ClassGradeBlock(classGrade: $viewModel.courses[index])
                                            .environmentObject(viewModel)
                                    }, onDelete: {
                                        courseToDelete = viewModel.courses[index]
                                    }, onEdit: editCourseView(originalCourse: $viewModel.courses[index]).environmentObject(viewModel))
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
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
                        } catch {
                            print("Error deleting all courses: \(error)")
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete all \(filteredCourses.count) courses? This action cannot be undone.")
                }
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(.keyboard)
                .padding(.horizontal, 20)
                
                
                menuButtonAdd(isMenuPresented: $menuIsPresentedCourse, menuItems: [
                    menuItem(destination: addCourseView().environmentObject(viewModel), optionName: "Add Course", icon: "plus.circle.fill"),
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
                            didAppear = true
                        } catch {
                            print("error: \(error)")
                        }
                    }
                } else if newValue {
                    didAppear = false
                    viewModel.courses = []
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
                            Text("\(year)")
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

#Preview {
    classesView(showSignInView: .constant(false))
        .environmentObject(gradesViewModel())
}

