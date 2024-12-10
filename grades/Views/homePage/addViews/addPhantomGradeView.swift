//
//  addGradeView 2.swift
//  grades
//
//  Created by Mayank Tiku on 11/29/24.
//


//
//  AddGradeView.swift
//  grades
//
//  Created by Mayank Tiku on 10/31/24.
//


import SwiftUI

struct addPhantomGradeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddGradeViewModel()
    
    @State private var isPressed = false
    @Binding var course: course
    
    @Binding var showPhantom: Bool
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.primaryCol.edgesIgnoringSafeArea(.all).removeFocusOnTap()
                VStack(spacing: 16) {
                    // Assignment Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Assignment Name")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol)
                        
                        TextField("", text: $viewModel.name, prompt: Text("Enter assignment name").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                            .textFieldStyle(ModernTextFieldStyle())
                            .autocorrectionDisabled()
                    }
                    .removeFocusOnTap()
                    
                    // Points Section
                    HStack(spacing: 16) {
                        // Points Earned
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Points Earned")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            
                            TextField("", text: $viewModel.pointsEarned, prompt: Text("Enter here").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        .removeFocusOnTap()
                        
                        
                        // Total Points
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Points")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol)
                            
                            TextField("100", text: $viewModel.totalPoints, prompt: Text("Enter here").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                                .textFieldStyle(ModernTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                    .removeFocusOnTap()
                    
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol)
                        
                        DatePicker("Assignment Date",
                                   selection: $viewModel.date,
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .accentColor(.terCol)
                        .colorScheme(.dark)
                    }
                    
                    //            Spacer(minLength: 0)
                    
                    // Save Button
                    Button(action: {
                        do {
                            isPressed = true
                            try viewModel.saveGrade(&course, isPhan: true)
                            withAnimation {
                                showPhantom = true
                            }
                            dismiss()
                            isPressed = false
                        } catch {
                            isPressed = false
                            print(error)
                        }
                    }) {
                        Text(isPressed ? "Adding Grade..." : "Add Phantom Grade")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(isPressed ? .gray : .secCol)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isValidInput ? Color.terCol : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.isValidInput)
                }
                .padding()
                .navigationTitle("Add Phantom Grade")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitleTextColor(.secCol)
            }
        }
    }
}
