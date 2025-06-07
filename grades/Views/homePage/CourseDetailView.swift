//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct CourseDetailView: View {
    @Binding var course: course
    @EnvironmentObject var viewModel: gradesViewModel
    
    @State var menuIsVisible: Bool = false
    
    @State var isShowingPhantom: Bool = false
    
    var sortedArray: [grade] {
        return course.grades.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    // Header Card
                    CourseHeaderCard(course: $course, isShowingPhantom: $isShowingPhantom)
                        .environmentObject(viewModel)
                    
                    // phantom assignments
                    if isShowingPhantom && course.grades.contains( where: { $0.isPhantom } ) {
                        Text("Phantom Grades")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom(course.grades.isEmpty ? "ProductSans-Regular" : "ProductSans-Bold", size: 20))
                        
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        VStack(alignment: .leading, spacing: 12) {
                            
                            ForEach(sortedArray) { grade in
                                if grade.isPhantom {
                                    SwipeToDeleteView(content: {
                                        GradeCard(grade: grade, isPoints: course.isPoints)
                                    }, onDelete: {
                                        if let index = course.grades.firstIndex(of: grade) {
                                            course.grades.remove(at: index)
                                        }
                                        if !course.isPoints {
                                            for i in course.categories.indices {
                                                if course.categories[i].grades.contains(grade) {
                                                    course.categories[i].grades.removeAll(where: { $0 == grade})
                                                }
                                            }
                                        }
                                        try? coursesManager.shared.setCourse(data: course)
                                    }, onEdit: editGradeView(grade: grade, course: $course))
                                }
                            }
                        }
                    }
                    
                    // normal assignments
                    Text(course.grades.isEmpty ? "No Grades" : "Grades (Sorted by Date)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(course.grades.isEmpty ? "ProductSans-Regular" : "ProductSans-Bold", size: 20))
                    
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {

                        ForEach(course.grades) { grade in
                            if !grade.isPhantom {
                                SwipeToDeleteView(content: {
                                    GradeCard(grade: grade, isPoints: course.isPoints)
                                }, onDelete: {
                                    if let index = course.grades.firstIndex(of: grade) {
                                        course.grades.remove(at: index)
                                    }
                                    if !course.isPoints {
                                        for i in course.categories.indices {
                                            if course.categories[i].grades.contains(grade) {
                                                course.categories[i].grades.removeAll(where: { $0 == grade})
                                            }
                                        }
                                    }
                                    try? coursesManager.shared.setCourse(data: course)
                                }, onEdit: editGradeView(grade: grade, course: $course))
                            }
                        }
                        .onAppear {
                            isShowingPhantom = course.grades.contains(where: { $0.isPhantom } )
                        } 
                    }
                }
                .ignoresSafeArea(.keyboard)
                .padding()
            }
            if course.isPoints {
                menuButtonAdd(isMenuPresented: $menuIsVisible, menuItems: [
                    menuItem(destination: addGradeView(course: $course), optionName: "Add Grade", icon: "books.vertical.fill"),
                    menuItem(destination: addPhantomGradeView(course: $course, showPhantom: $isShowingPhantom), optionName: "Add Phantom Grade", icon: "books.vertical"),
                    menuItem(action: {
                        isShowingPhantom.toggle()
                    }, optionName: isShowingPhantom ? "Hide Phantom Grades" : "Show Phantom Grades", icon: "arrow.right.circle", isAnimated: true)
                    ]
                )
            } else {
                menuButtonAdd(isMenuPresented: $menuIsVisible, menuItems: [
                    menuItem(destination: addGradeView(course: $course), optionName: "Add Grade", icon: "books.vertical.fill"),
                    menuItem(destination: addPhantomGradeView(course: $course, showPhantom: $isShowingPhantom), optionName: "Add Phantom Grade", icon: "books.vertical"),
                    menuItem(action: {
                        isShowingPhantom.toggle()
                    }, optionName: isShowingPhantom ? "Hide Phantom Grades" : "Show Phantom Grades", icon: "arrow.right.circle", isAnimated: true),
                    menuItem(destination: editCategoriesView(course: course), optionName: "Edit Categories", icon: "tray.2.fill")
                    ]
                )
            }
        }
        .navigationTitle(course.name)
        .navigationBarBackButtonHidden(menuIsVisible)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
}

// Header card showing course summary
struct CourseHeaderCard: View {
    @Binding var course: course
    @Binding var isShowingPhantom: Bool
    @EnvironmentObject var viewModel: gradesViewModel
    
    var isPreview: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(isPreview ? course.name : course.teacher)
                        .font(.custom("ProductSans-Bold", size: 24))
                        .foregroundColor(.secCol)
                }
                .frame(maxWidth: 140, maxHeight: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack {
                        VStack(alignment: isShowingPhantom ? .center : .trailing) {
                            Text(course.average.averageToGrade(settings: viewModel.userSettings))
                                .font(.custom("ProductSans-Bold", size: 36))
                                .foregroundColor(.secCol)
                            Text("\(course.average.roundedGrade())%")
                                .font(.custom("ProductSans-Regular", size: 18))
                                .foregroundColor(.secCol)
                        }
                        if isShowingPhantom {
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secCol)
                                .fontWeight(.bold)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            VStack {
                                Text(course.phantomAverage.averageToGrade(settings: viewModel.userSettings))
                                    .font(.custom("ProductSans-Bold", size: 36))
                                    .foregroundColor(.secCol)
                                Text("\(course.phantomAverage.roundedGrade())%")
                                    .font(.custom("ProductSans-Regular", size: 18))
                                    .foregroundColor(.secCol)
                            }
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
    }
}

// Individual grade card
struct GradeCard: View {
    let grade: grade
    let isPoints: Bool
    let dateFormatter: DateFormatter
    let gradeCat: String
    let dateString: String
    let gradeWeightString: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.name)
                    .font(.custom("ProductSans-Regular", size: 18))
                    .foregroundColor(.secCol)
                Text("\(dateString)"+" - "+"\(gradeCat)"+"\(gradeWeightString)")
                    .font(.custom("ProductSans-Regular", size: 14))
                    .foregroundColor(.secCol)
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .trailing) {
                Text("\(grade.earned.removeZerosFromEnd())/\(grade.points.removeZerosFromEnd())")
                    .font(.custom("ProductSans-Bold", size: 18))
                    .foregroundColor(.secCol)

                Text("\(grade.percentage.roundedGrade())%")
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.secCol.opacity(0.9))
            }
        }
        .padding()
        .background(gradeBackgroundColor(percentage: grade.percentage))
        .cornerRadius(12)
        .onAppear {
            dateFormatter.dateFormat = "YY/MM/dd"
        }
    }
    
    private func gradeBackgroundColor(percentage: Double) -> Color {
        if percentage >= 90 {
            return Color.green.opacity(0.3)
        } else if percentage >= 80 {
            return Color.blue.opacity(0.3)
        } else if percentage >= 70 {
            return Color.yellow.opacity(0.3)
        } else if percentage >= 60 {
            return Color.orange.opacity(0.3)
        } else {
            return Color.red.opacity(0.3)
        }
    }
    
    init(grade: grade, isPoints: Bool) {
        self.grade = grade
        self.isPoints = isPoints
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        
        self.dateString = dateFormatter.string(from: grade.date)
        self.gradeCat = grade.category ?? "No Category"
        self.gradeWeightString = grade.weight != 1 ? " - \(grade.weight)x" : ""
    }
}

//#Preview {
//    NavigationView {
//        CourseDetailView(course: course(
//            name: "AP Lang",
//            teacher: "fentussy",
//            isPoints: true,
//            grades: [
//                grade(name: "Dialectical Journal", points: 100, earned: 95, weight: 1, date: Date())
////                grade(points: 100, earned: 92, weight: 1, date: Date())
//            ])
//        )
//    }
//}


#Preview {
    @Previewable @State var c = course(
        name: "AP Calculus BC",
        teacher: "Anatoly Fonarev",
        isPoints: true,
        grades: [
            grade(name: "Test grade", points: 100, earned: 95, weight: 1.5, date: Date()),
        grade(name: "Test grade 2", points: 100, earned: 85, weight: 1, date: Date()),
        grade(name: "Test grade 3", points: 100, earned: 75, weight: 1, date: Date())
        ]
    )
    NavigationStack {
        CourseDetailView(course: $c)
            .environmentObject(gradesViewModel())
    }
}
