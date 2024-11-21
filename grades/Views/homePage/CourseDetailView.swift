//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct CourseDetailView: View {
    @Binding var course: course
    
    @State var menuIsVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    // Header Card
                    CourseHeaderCard(course: course)
                    Text(course.grades.isEmpty ? "No assignments" : "Assignments")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(course.grades.isEmpty ? "ProductSans-Regular" : "ProductSans-Bold", size: 20))
                    
                        .foregroundColor(.white)
                        .padding(.horizontal)
              
                    VStack(alignment: .leading, spacing: 12) {

                        ForEach(course.grades) { grade in
                            SwipeToDeleteView {
                                GradeCard(grade: grade, isPoints: course.isPoints)
                            } onDelete: {
                                if let index = course.grades.firstIndex(of: grade) {
                                    course.grades.remove(at: index)
                                }
                                try? coursesManager.shared.setCourse(data: course)
                            }
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
                .padding()
            }

            menuButtonAdd(isMenuPresented: $menuIsVisible, menuItems: [
                menuItem(destination: addGradeView(course: $course), optionName: "Add Grade", icon: "books.vertical.fill")
                ]
            )
        }
        .navigationTitle(course.name)
        .navigationBarBackButtonHidden(menuIsVisible)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
}

// Header card showing course summary
struct CourseHeaderCard: View {
    let course: course
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(course.teacher)
                        .font(.custom("ProductSans-Bold", size: 24))
                        .foregroundColor(.secCol)
//                    Text(course.isPoints ? "Points Based" : "Weighted Categories")
//                        .font(.custom("ProductSans-Regular", size: 18))
//                        .foregroundColor(.secCol.opacity(0.8))
                }
                .frame(maxWidth: 140, maxHeight: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(course.averageToGrade())
                        .font(.custom("ProductSans-Bold", size: 36))
                        .foregroundColor(.secCol)
                    Text("\(course.average.roundedGrade())%")
                        .font(.custom("ProductSans-Regular", size: 18))
                        .foregroundColor(.secCol)
                }
            }
        }
        .padding()
        .background(.primaryCol)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

//// Individual category card
//struct CategoryCard: View {
//    let category: categoy
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(category.name)
//                    .font(.system(size: 16, weight: .semibold, design: .rounded))
//                    .foregroundColor(.white)
//            }
//            
//            Spacer()
//            
//            Text("\(Int(category.weight))%")
//                .font(.system(size: 16, weight: .bold, design: .rounded))
//                .foregroundColor(.white)
//        }
//        .padding()
//        .background(Color.bgBlue.brightness(-0.04))
//        .cornerRadius(12)
//    }
//}

// Individual grade card
struct GradeCard: View {
    let grade: grade
    let isPoints: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(grade.name)
                    .font(.custom("ProductSans-Regular", size: 18))
                    .foregroundColor(.secCol)
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .trailing) {
                if isPoints {
                    Text("\(grade.earned.removeZerosFromEnd())/\(grade.points.removeZerosFromEnd())")
                        .font(.custom("ProductSans-Bold", size: 18))
                        .foregroundColor(.secCol)
                }
                Text("\(grade.percentage.roundedGrade())%")
                    .font(.custom("ProductSans-Regular", size: 16))
                    .foregroundColor(.secCol.opacity(0.9))
            }
        }
        .padding()
        .background(gradeBackgroundColor(percentage: grade.percentage))
        .cornerRadius(12)
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
        grade(name: "Test grade", points: 100, earned: 95, weight: 1, date: Date()),
        grade(name: "Test grade 2", points: 100, earned: 85, weight: 1, date: Date()),
        grade(name: "Test grade 3", points: 100, earned: 75, weight: 1, date: Date())
        ]
    )
    CourseDetailView(course: $c)
}
