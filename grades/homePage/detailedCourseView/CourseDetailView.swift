//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct CourseDetailView: View {
    @Binding var course: course
    
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(alignment: .leading, spacing: 10) {
                        CourseHeaderCard(course: course)
                        Text(course.grades.isEmpty ? "No assignments" : "Assignments")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 20, weight: course.grades.isEmpty ? .regular: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
              
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
        }
        .toolbar(content: {
            ToolbarItem {
                NavigationLink {
                    addGradeView(course: $course)
                        .ignoresSafeArea(.keyboard)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.secCol)
                }
            }
        })
        .navigationTitle(course.name)
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
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.secCol)
                    Text(course.isPoints ? "Points Based" : "Weighted Categories")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secCol.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(course.averageToGrade())
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.secCol)
                    Text("\(course.average.roundedGrade())%")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
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
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.secCol)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if isPoints {
                    Text("\(Int(grade.earned))/\(Int(grade.points))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.secCol)
                }
                Text("\(grade.percentage.roundedGrade())%")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
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

struct SwipeToDeleteView<Content: View>: View {
    let content: Content
    let onDelete: () -> Void
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    private let deleteThreshold: CGFloat = -75
    
    init(@ViewBuilder content: () -> Content, onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack {
            
            // Content
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            // Prevent swipe to the right in default position
                            if offset == 0 && gesture.translation.width > 0 {
                                return
                            }
                            
                            // Prevent drag more than deleteThreshold points
                            if gesture.translation.width < deleteThreshold {
                                return
                            }
                            
                            // Prevent swipe againt to the left if it's already swiped
                            if offset == deleteThreshold && gesture.translation.width < 0 {
                                return
                            }
                            
                            // If view already swiped to the left and we start dragging to the right
                            // Firstly will check if it's swiped left
                            if offset >= deleteThreshold {
                                // And here checking if swiped to the right more than swipeRightLimit points
                                // If more - need to set the view to zero position
                                if gesture.translation.width > 0 {
                                    self.offset = 0
                                    return
                                }
                                
                                // Check if only swiping to the right - update distance by minus deleteThreshold points
                                if offset != 0 && gesture.translation.width > 0 {
                                    self.offset = deleteThreshold + gesture.translation.width
                                    return
                                }
                            }
                                
                            self.offset = gesture.translation.width
                        }
                        .onEnded { gesture in
                            withAnimation {
                                // Left swipe handle:
                                if self.offset < -30 {
                                    self.offset = deleteThreshold
                                    return
                                }
                                if self.offset < deleteThreshold {
                                    self.offset = deleteThreshold
                                    return
                                }
                                
                                // Right swipe handle:
                                if gesture.translation.width > 30 {
                                    self.offset = 0
                                    return
                                }
                                if gesture.translation.width < 30 {
                                    self.offset = deleteThreshold
                                    return
                                }
                                
                                self.offset = 0
                            }
                        }
                )
            Group {
                Button(action: {
                    onDelete()
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.terCol)
                        .overlay {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                }
                .offset(x: 40+offset)
            }.frame(width: 0)
        }
    }
}
