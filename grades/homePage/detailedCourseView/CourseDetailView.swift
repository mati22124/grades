//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct CourseDetailView: View {
    let course: course
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    CourseHeaderCard(course: course)
                    
//                    // Categories Section
//                    if !course.categories.isEmpty {
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Categories")
//                                .font(.system(size: 20, weight: .bold, design: .rounded))
//                                .foregroundColor(.white)
//                                .padding(.horizontal)
//                            
//                            ForEach(course.categories, id: \.name) { category in
//                                CategoryCard(category: category)
//                            }
//                        }
//                    }
                    
                    // Grades Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.grades.isEmpty ? "No assignments":"Assignments")
                            .font(.system(size: 20, weight: course.grades.isEmpty ? .regular: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ForEach(course.grades) { grade in
                            GradeCard(grade: grade, isPoints: course.isPoints)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
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
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text(course.isPoints ? "Points Based" : "Weighted Categories")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(course.averageToGrade())
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("\(course.average.roundedGrade())%")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color.bgBlue.brightness(-0.08))
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
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if isPoints {
                    Text("\(Int(grade.earned))/\(Int(grade.points))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Text("\(grade.percentage.roundedGrade())%")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
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

#Preview {
    NavigationView {
        CourseDetailView(course: course(
            name: "AP Lang",
            teacher: "fentussy",
            isPoints: true,
            grades: [
                grade(name: "Dialectical Journal", points: 100, earned: 95, weight: 1, date: Date())
//                grade(points: 100, earned: 92, weight: 1, date: Date())
            ])
        )
    }
}
