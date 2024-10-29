//
//  gradesView.swift
//  grades
//
//  Created by Mayank Tiku on 9/27/24.
//

import SwiftUI

struct gradesView: View {
    let backgroundColor = Color(red: 0.9, green: 0.95, blue: 1.0) // Lighter sky blue
    let accentColor = Color(red: 1.0, green: 0.8, blue: 0.0) // Gold accent
    @Binding var showSignInView: Bool
    
    @StateObject var viewModel = gradesViewModel()
    
    var body: some View {
        ZStack {
            Color.bgBlue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ScrollView {
                        ForEach(viewModel.courses) { classGrade in
                    VStack(spacing: 12) {
                            ClassGradeBlock(classGrade: classGrade)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 20)
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    //add course logic
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.white)
                }
            }
        })
        .onAppear(perform: {
            Task {
                do {
                    try await viewModel.loadCurrentUser()
                } catch {
                    print("error: \(error)")
                }
            }
        })
        .onChange(of: showSignInView, { _, newValue in
            if newValue == false {
                Task {
                    do {
                        try await viewModel.loadCurrentUser()
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        })
    }
}

struct ClassGradeBlock: View {
    let classGrade: course
    
    var body: some View {
        HStack {
            VStack {
                Text(classGrade.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.mainBlue) 
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(classGrade.teacher)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.mainBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text("\(classGrade.average.removeZerosFromEnd())")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.mainBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.white) //Color.accentRed.brightness(-0.08)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .padding()
        .background(.white) //Color.bgBlue.opacity(0.75)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    gradesView(showSignInView: .constant(false))
}

