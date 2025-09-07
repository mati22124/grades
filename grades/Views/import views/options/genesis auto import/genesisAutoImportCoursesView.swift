//
//  genesisAutoImportCoursesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/6/25.
//

import SwiftUI

struct genesisAutoImportCoursesView: View {
    @Binding var coursesTemp: [course]
    
    @EnvironmentObject var gradesVm: gradesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCourseDetails: Bool = false
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Review Imported Courses")
                        .font(.custom("ProductSans-Bold", size: 22))
                        .foregroundColor(.secCol)
                        .padding(.bottom, 6)
                    
                    Text("\(coursesTemp.count) courses found. Tap on a course to preview its grades.")
                        .font(.custom("ProductSans-Regular", size: 16))
                        .foregroundColor(.secCol.opacity(0.8))
                }
                .padding(.top, 10)
                
                ScrollView {
                    ForEach($coursesTemp) { $course in
                        NavigationLink {
                            courseImportPreviewView(course: $course)
                                .environmentObject(gradesVm)
                        } label: {
                            ClassGradeBlock(classGrade: $course)
                                .environmentObject(gradesVm)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 15) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Cancel")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showCourseDetails = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Next")
                                .font(.custom("ProductSans-Bold", size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(coursesTemp.isEmpty ? Color.gray : Color.terCol)
                        .cornerRadius(10)
                    }
                    .disabled(coursesTemp.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Genesis Auto Import")
        .navigationBarTitleTextColor(.secCol)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCourseDetails) {
            NavigationStack {
                SmartCourseImportView(coursesToImport: $coursesTemp)
                .environmentObject(gradesVm)
                .onDisappear {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        genesisAutoImportCoursesView(coursesTemp: .constant([]))
            .environmentObject(gradesViewModel())
    }
}
