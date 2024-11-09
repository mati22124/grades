//
//  AddGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 10/31/24.
//


import SwiftUI

struct addGradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddGradeViewModel()
    
    @Binding var course: course
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Assignment Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Assignment Name")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        TextField("", text: $viewModel.name, prompt: Text("Enter assignment name").foregroundStyle(.lightGray).font(.custom("ProductSans-Regular", size: 16)))
                            .textFieldStyle(ModernTextFieldStyle())
                            .autocorrectionDisabled()
                    }
                    
                    // Points Section
                    HStack(spacing: 16) {
                        // Points Earned
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Points Earned")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            TextField("", text: $viewModel.pointsEarned, prompt: Text("Enter here").foregroundStyle(.lightGray).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        // Total Points
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Points")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            TextField("100", text: $viewModel.totalPoints, prompt: Text("Enter here").foregroundStyle(.lightGray).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        DatePicker("Assignment Date",
                                 selection: $viewModel.date,
                                 displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .accentColor(.accentRed)
                        .colorScheme(.dark)
                    }
                    
                    // Save Button
                    Button(action: {
                        do {
                            try viewModel.saveGrade(&course)
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }) {
                        Text("Add Grade")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isValidInput ? Color.accentRed : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.isValidInput)
                }
                .padding()
            }
        }
        .navigationTitle("Add Grade")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NavigationView {
//        addGradeView(course: course(
//            name: "Sample Course",
//            teacher: "John Doe",
//            isPoints: true,
//            grades: []
//        ))
//    }
//}
