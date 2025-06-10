//
//  FirstLaunchView.swift
//  grades
//
//  Created on 6/8/2025.
//

import SwiftUI

struct FirstLaunchView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.primaryCol
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)
                    
                    FeaturesPage()
                        .tag(1)
                    
                    MigrationPage(isPresented: $isPresented)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.terCol)
                .padding(.bottom, 20)
            
            Text("Welcome to Grades 4.0")
                .font(.custom("ProductSans-Bold", size: 36))
                .foregroundColor(.secCol)
            
            Text("HUGE UPDATE!")
                .font(.custom("ProductSans-Bold", size: 24))
                .foregroundColor(.terCol)
            
            Text("Major new features to track your grades")
                .font(.custom("ProductSans-Regular", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.secCol.opacity(0.8))
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FeaturesPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("What's New")
                .font(.custom("ProductSans-Bold", size: 36))
                .foregroundColor(.secCol)
                .padding(.top, 60)
                .padding(.horizontal, 30)
            
            VStack(alignment: .leading, spacing: 25) {
                FeatureItem(
                    icon: "chart.bar.fill",
                    title: "NEW Reports Tab",
                    description: "Calculate all GPA types with course credits and weights"
                )
                
                FeatureItem(
                    icon: "text.badge.checkmark",
                    title: "Final Grades",
                    description: "Add final letter grades for accurate GPA"
                )
                
                FeatureItem(
                    icon: "paintbrush.fill",
                    title: "Fresh Design",
                    description: "Cleaner look, easier on the eyes"
                )
                
                FeatureItem(
                    icon: "calendar",
                    title: "Multiple Marking Periods",
                    description: "Store grades from previous years"
                )
                
                FeatureItem(
                    icon: "slider.horizontal.3",
                    title: "Customization",
                    description: "Grade rounding & custom GPA scales"
                )
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct MigrationPage: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.terCol)
                .padding(.top, 60)
            
            Text("Important Notice")
                .font(.custom("ProductSans-Bold", size: 32))
                .foregroundColor(.secCol)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("To use new features:")
                    .font(.custom("ProductSans-Bold", size: 22))
                    .foregroundColor(.secCol)
                
                VStack(alignment: .leading, spacing: 15) {
                    MigrationPoint(text: "Edit courses manually OR reimport from Genesis")
                    MigrationPoint(text: "Update science course credits")
                    MigrationPoint(text: "No bulk editing available")
                    MigrationPoint(text: "Reimporting will lose phantom grades")
                }
                
                Text("Sorry for the inconvenience - this is one-time only")
                    .font(.custom("ProductSans-Regular", size: 18))
                    .foregroundColor(.secCol.opacity(0.7))
                    .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                isPresented = false
            }) {
                Text("Got it!")
                    .font(.custom("ProductSans-Bold", size: 20))
                    .foregroundColor(.primaryCol)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.terCol)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(.terCol)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.custom("ProductSans-Bold", size: 20))
                    .foregroundColor(.secCol)
                Text(description)
                    .font(.custom("ProductSans-Regular", size: 18))
                    .foregroundColor(.secCol.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

struct MigrationPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(.terCol)
                .font(.system(size: 18))
            Text(text)
                .font(.custom("ProductSans-Regular", size: 18))
                .foregroundColor(.secCol)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    FirstLaunchView(isPresented: .constant(true))
}