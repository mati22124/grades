//
//  genesisAutoImport.swift
//  grades
//
//  Created by Mayank Tiku on 9/4/25.
//

import SwiftUI

struct genesisAutoImport: View {
    @AppStorage("genesisEmail") private var username: String = ""
    @AppStorage("genesisPassword") private var password: String = ""
    @AppStorage("genesisURL") private var genesisURL: String = ""
    @State private var isShowingEdit: Bool = false
    
    @StateObject private var genesisVm = autoImportViewModel()
    
    @EnvironmentObject var gradesVm: gradesViewModel
    
    @State private var coursesTemp: [course] = []
    
    @State private var showCoursesView: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showError: Bool = false
    
    @State private var progressMessage: String = ""
    @State private var progressValue: Double = 0.0
    @State private var totalCourses: Int = 0
    @State private var currentCourse: Int = 0
    
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Genesis Auto Import")
                        .font(.custom("ProductSans-Bold", size: 22))
                        .foregroundColor(.secCol)
                        .padding(.bottom, 6)
                    
                    Text("Enter your Genesis credentials to automatically import your grades")
                        .font(.custom("ProductSans-Regular", size: 16))
                        .foregroundColor(.secCol.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    // Username field
                    TextField("", text: $username, prompt: Text("Username").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.custom("ProductSans-Regular", size: 16))
                        .tint(.white)
                    
                    // Password field
                    SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.secCol).font(.custom("ProductSans-Regular", size: 16)))
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .font(.custom("ProductSans-Regular", size: 16))
                        .tint(.white)
                    
                    // Genesis URL display with edit button
                    Button {
                        genesisURL = genesisURL.isEmpty ? "https://" : genesisURL
                        isShowingEdit = true
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                                .imageScale(.small)
                            Image(systemName: "link")
                                .imageScale(.small)
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .background(.terCol)
                        .clipShape(Capsule())
                    }
                    Spacer()
                    HStack {
                        Button {
                            pullCourses()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Get grades")
                                        .bold()
                                }
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.terCol)
                            .clipShape(Capsule())
                        }
                        .disabled(isLoading)
                    }
                    
                    // Progress indicator
                    if isLoading && !progressMessage.isEmpty {
                        VStack(spacing: 8) {
                            Text(progressMessage)
                                .font(.custom("ProductSans-Regular", size: 14))
                                .foregroundColor(.secCol.opacity(0.9))
                                .animation(.easeInOut(duration: 0.3), value: progressMessage)
                            
                            ProgressView(value: progressValue, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: .terCol))
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                .animation(.easeInOut(duration: 0.3), value: progressValue)
                        }
                        .padding(.horizontal, 40)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.top, 10)
                
                Text("All information is processed locally on your device. Your password and sensitive data are never transmitted or stored by our servers.")
                    .font(.custom("ProductSans-Regular", size: 14))
                    .foregroundColor(.secCol.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationDestination(isPresented: $showCoursesView) {
            genesisAutoImportCoursesView(coursesTemp: $coursesTemp)
                .environmentObject(gradesVm)
        }
        .sheet(isPresented: $isShowingEdit, content: {
            GenesisURLEditView()
        })
        .alert("Error", isPresented: $showError) {
            Button("OK") { showError = false }
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
    }
    
    func pullCourses() {
        Task {
            isLoading = true
            progressMessage = "Authenticating..."
            progressValue = 0.0
            coursesTemp = []
            
            do {
                try await genesisVm.authenticate(baseURL: genesisURL, username: username, password: password)
                
                progressMessage = "Fetching courses..."
                progressValue = 0.1
                
                let courses = try await genesisVm.getTempCourses(baseURL: genesisURL)
                if courses.isEmpty {
                    throw importError.nothingInGradebook
                }
                totalCourses = courses.count
                currentCourse = 0
                
                for (index, course) in courses.enumerated() {
                    currentCourse = index + 1
                    progressMessage = "Processing course \(currentCourse) of \(totalCourses)"
                    progressValue = 0.1 + (0.9 * Double(index) / Double(max(totalCourses, 1)))
                    
                    let htmlCourse = try await genesisVm.getCourseHTML(baseURL: genesisURL, courseCode: course.courseCode, courseSection: course.section, markingPeriod: course.MP)
                    let officialCourseNil = try genesisVm.parseCourseHTML(html: htmlCourse)
                    guard let realCourse = officialCourseNil else {
                        print("couldnt parse course named \(course.name+" - "+course.MP)")
                        continue
                    }
                    realCourse.teacher = course.teacher
                    realCourse.markingPeriod = Int(course.MP.filter { $0.isNumber })
                    coursesTemp.append(realCourse)
                    try await Task.sleep(for: .milliseconds(200))
                }
                
                progressValue = 1.0
                progressMessage = "Complete!"
                
                try await Task.sleep(for: .milliseconds(400))
                
                isLoading = false
                progressMessage = ""
                
                if !coursesTemp.isEmpty {
                    showCoursesView = true
                }
            } catch {
                isLoading = false
                progressMessage = ""
                errorMessage = error.localizedDescription
                showError = true
                print(error)
            }
        }
    }
}

#Preview {
    genesisAutoImport()
        .environmentObject(gradesViewModel())
}

enum AuthenticationError: Error {
    case authenticationFailed(String)
    case networkError(String)
    case invalidResponse
}

extension AuthenticationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authenticationFailed(let message):
            return NSLocalizedString("Authentication failed: \(message)", comment: "Authentication Error")
        case .networkError(let message):
            return NSLocalizedString("Network error: \(message)", comment: "Network Error")
        case .invalidResponse:
            return NSLocalizedString("Invalid response from Genesis. Please check your URL and try again.", comment: "Invalid Response")
        }
    }
}
