//
//  genesisImportView.swift
//  grades
//
//  Created by Mayank Tiku on 1/7/25.
//

import SwiftUI

struct genesisImportView: View {
    @State private var isShowingView: Bool = false
    
    @State private var isShowingEdit: Bool = false
    @State private var url: String = ""

    @State var showAlert: Bool = false
    
    @StateObject var webVM = WebViewModel()
    @EnvironmentObject var gradesVm: gradesViewModel

    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        ZStack {
            Color.primaryCol.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if webVM.ccc.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("After you log in:")
                            .font(.custom("ProductSans-Bold", size: 22))
                            .foregroundColor(.secCol)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "hand.tap.fill")
                                    .foregroundColor(.mainBlue)
                                Text("Click on to each one of your points based courses.")
                                    .font(.custom("ProductSans-Regular", size: 18))
                                    .foregroundColor(.secCol)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.secCol)
                                Text("A checkmark appears when a course is succesfully imported")
                                    .font(.custom("ProductSans-Regular", size: 18))
                                    .foregroundColor(.secCol)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: "person.fill.checkmark")
                                    .foregroundColor(.green)
                                Text("When finished, swipe the browser down to review the courses")
                                    .font(.custom("ProductSans-Regular", size: 18))
                                    .foregroundColor(.secCol)
                            }
                            
                            
                            
                            Text("All information is processed locally on your device. Your password and sensitive data are never transmitted or stored by our servers.")
                                .font(.custom("ProductSans-Regular", size: 14))
                                .foregroundColor(.secCol)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                Button {
                    url = "https://"
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
                .alert("Edit URL", isPresented: $isShowingEdit) {
                    TextField("Enter the full URL here", text: $url)
                    Button("OK", action: { // TODO: regex to verify url
                        webVM.url = URL(string: url)!
                        webVM.loadUrl()
                    })
                } message: {
                    Text("Enter your genesis URL here")
                }
                
                
                Button {
                    isShowingView = true
                } label: {
                    HStack {
                        Image(systemName: "safari.fill")
                        Text("Open Browser")
                            .font(.custom("ProductSans-Bold", size: 16))
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(.terCol)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingView) {
                    ZStack {
                        WebView(webView: webVM.webView)
                        if webVM.anim {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundStyle(.white)
                                .animation(.easeInOut(duration: 0.5), value: 1)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 120, height: 120)
                                        .foregroundStyle(.black)
                                }
                        }
                    }
                }
                ScrollView {
                    ForEach($webVM.ccc) { $course in
                        NavigationLink {
                            courseImportPreviewView(course: $course)
                        } label: {
                            ClassGradeBlock(classGrade: $course)
                                .environmentObject(gradesViewModel())
                        }
                        .padding()
                    }
                }
                                
                Spacer()
                
                Button(action: {
                    do {
                        gradesVm.courses.append(contentsOf: webVM.ccc)
                        try gradesVm.publishCourses()
                        showAlert = true
                        webVM.ccc.removeAll()
                    } catch {
                        print(error)
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Done")
                            .font(.custom("ProductSans-Bold", size: 16))
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(webVM.ccc.isEmpty ? .gray : .terCol)
                    .cornerRadius(10)
                }
                .padding(.bottom)
                .disabled(webVM.ccc.isEmpty)
                .alert("Import Successful", isPresented: $showAlert) {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Check out the imported courses in the grades tab")
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Genesis Import (beta)")
        .navigationBarTitleTextColor(.secCol)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    genesisImportView()
        .environmentObject(gradesViewModel())
}
