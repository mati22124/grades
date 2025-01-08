//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 12/19/24.
//


//
//  CourseDetailView.swift
//  grades
//
//  Created by Mayank Tiku on 10/29/24.
//


import SwiftUI

struct courseImportPreviewView: View {
    @Binding var course: course
    
    @State var menuIsVisible: Bool = false
        
    var body: some View {
        ZStack {
            Color.primaryCol.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    // Header Card
                    CourseHeaderCard(course: $course, isShowingPhantom: .constant(false), isPreview: true)
                    
                    // phantom assignments
                    // normal assignments
                    Text(course.grades.isEmpty ? "No Grades" : "Grades")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(course.grades.isEmpty ? "ProductSans-Regular" : "ProductSans-Bold", size: 20))
                    
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {

                        ForEach(course.grades) { grade in
                            if !grade.isPhantom {
                                GradeCard(grade: grade, isPoints: course.isPoints)
                            }
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
                .padding()
            }
        }
        .navigationTitle(course.name)
        .navigationBarBackButtonHidden(menuIsVisible)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleTextColor(.secCol)
    }
}


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
    courseImportPreviewView(course: $c)
}
