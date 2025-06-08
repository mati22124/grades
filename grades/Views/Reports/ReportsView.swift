//
//  ReportsView.swift
//  grades
//
//  Created by Mayank Tiku on 6/7/25.
//

import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var gradesVM: gradesViewModel
    @StateObject private var reportsVM = ReportsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primaryCol.ignoresSafeArea()
                
                if reportsVM.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .terCol))
                            .scaleEffect(1.5)
                        Text("Calculating GPAs...")
                            .font(.custom("ProductSans-Regular", size: 16))
                            .foregroundColor(.secCol)
                            .padding(.top, 20)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 18) {
                            // Note about refreshing
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.terCol)
                                Text("If final grades aren't showing, switch tabs and return to refresh")
                                    .font(.custom("ProductSans-Regular", size: 12))
                                    .foregroundColor(.secCol.opacity(0.8))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            
                            // Cumulative GPAs
                            VStack(spacing: 12) {
                                Text("Cumulative GPAs")
                                    .font(.custom("ProductSans-Bold", size: 24))
                                    .foregroundColor(.secCol)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                // All Courses Cumulative GPA
                                if reportsVM.cumulativeGPA > 0 {
                                    GPACard(
                                        title: "All Courses",
                                        gpa: reportsVM.cumulativeGPA,
                                        subtitle: "Cumulative - All Years",
                                        isHighlighted: true
                                    )
                                    .padding(.horizontal)
                                }
                                
                                // Core Cumulative GPA
                                if reportsVM.cumulativeCoreGPA > 0 {
                                    GPACard(
                                        title: "Core Classes",
                                        gpa: reportsVM.cumulativeCoreGPA,
                                        subtitle: "Cumulative - All Years",
                                        isHighlighted: true
                                    )
                                    .padding(.horizontal)
                                }
                                
                                // Unweighted Cumulative GPA
                                if reportsVM.cumulativeUnweightedGPA > 0 {
                                    GPACard(
                                        title: "Unweighted",
                                        gpa: reportsVM.cumulativeUnweightedGPA,
                                        subtitle: "Cumulative - All Years",
                                        isHighlighted: true
                                    )
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Years Section - grouped by year
                            if !reportsVM.yearlyGPAs.isEmpty {
                                YearByYearSection(
                                    yearlyGPAs: reportsVM.yearlyGPAs,
                                    markingPeriodGPAs: reportsVM.markingPeriodGPAs,
                                    coreYearlyGPAs: reportsVM.coreYearlyGPAs,
                                    coreMarkingPeriodGPAs: reportsVM.coreMarkingPeriodGPAs
                                )
                            }
                            
                            if reportsVM.yearlyGPAs.isEmpty && reportsVM.markingPeriodGPAs.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "chart.bar.xaxis")
                                        .font(.system(size: 60))
                                        .foregroundColor(.secCol.opacity(0.5))
                                    
                                    Text("No GPA Data Available")
                                        .font(.custom("ProductSans-Bold", size: 24))
                                        .foregroundColor(.secCol)
                                    
                                    Text("Add courses or final grades to see your GPA")
                                        .font(.custom("ProductSans-Regular", size: 16))
                                        .foregroundColor(.secCol.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Reports (BETA)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleTextColor(.secCol)
            .onAppear {
                reportsVM.calculateAllGPAs(courses: gradesVM.courses, userSettings: gradesVM.userSettings)
            }
            .onChange(of: gradesVM.courses) { _, _ in
                reportsVM.calculateAllGPAs(courses: gradesVM.courses, userSettings: gradesVM.userSettings)
            }
        }
    }
}

struct YearByYearSection: View {
    let yearlyGPAs: [GPAReport]
    let markingPeriodGPAs: [GPAReport]
    let coreYearlyGPAs: [GPAReport]
    let coreMarkingPeriodGPAs: [GPAReport]
    
    var allYears: [Int] {
        let years = Set(yearlyGPAs.map { $0.year } + coreYearlyGPAs.map { $0.year })
        return Array(years).sorted(by: >)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(allYears, id: \.self) { year in
                VStack(spacing: 16) {
                    // Year Header
                    Text(String(year) + "-" + String(year + 1))
                        .font(.custom("ProductSans-Bold", size: 22))
                        .foregroundColor(.secCol)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Year GPAs (All Courses and Core)
                    VStack(spacing: 12) {
                        // All Courses Year GPA
                        if let yearGPA = yearlyGPAs.first(where: { $0.year == year }) {
                            GPACard(
                                title: "All Courses",
                                gpa: yearGPA.gpa,
                                subtitle: "Academic Year",
                                credits: yearGPA.totalCredits,
                                courseCount: yearGPA.courseCount
                            )
                        }
                        
                        // Core Year GPA
                        if let coreYearGPA = coreYearlyGPAs.first(where: { $0.year == year }) {
                            GPACard(
                                title: "Core Classes",
                                gpa: coreYearGPA.gpa,
                                subtitle: "Academic Year",
                                credits: coreYearGPA.totalCredits,
                                courseCount: coreYearGPA.courseCount
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Marking Period GPAs for this year
                    let yearMPGPAs = markingPeriodGPAs.filter { $0.year == year }.sorted { ($0.markingPeriod ?? 0) < ($1.markingPeriod ?? 0) }
                    let yearCoreMPGPAs = coreMarkingPeriodGPAs.filter { $0.year == year }.sorted { ($0.markingPeriod ?? 0) < ($1.markingPeriod ?? 0) }
                    
                    if !yearMPGPAs.isEmpty || !yearCoreMPGPAs.isEmpty {
                        VStack(spacing: 12) {
                            Text("Marking Periods")
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(.secCol.opacity(0.8))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Get all unique marking periods for this year
                            let allMPs = Set(yearMPGPAs.compactMap { $0.markingPeriod } + yearCoreMPGPAs.compactMap { $0.markingPeriod }).sorted()
                            
                            ForEach(allMPs, id: \.self) { mp in
                                VStack(spacing: 8) {
                                    Text("MP \(mp)")
                                        .font(.custom("ProductSans-Bold", size: 14))
                                        .foregroundColor(.secCol.opacity(0.7))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // All Courses MP GPA
                                    if let mpGPA = yearMPGPAs.first(where: { $0.markingPeriod == mp }) {
                                        GPACard(
                                            title: "All Courses",
                                            gpa: mpGPA.gpa,
                                            subtitle: "MP \(mp)",
                                            credits: mpGPA.totalCredits,
                                            courseCount: mpGPA.courseCount
                                        )
                                    }
                                    
                                    // Core MP GPA
                                    if let coreMPGPA = yearCoreMPGPAs.first(where: { $0.markingPeriod == mp }) {
                                        GPACard(
                                            title: "Core Classes",
                                            gpa: coreMPGPA.gpa,
                                            subtitle: "MP \(mp)",
                                            credits: coreMPGPA.totalCredits,
                                            courseCount: coreMPGPA.courseCount
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct MarkingPeriodSection: View {
    let markingPeriodGPAs: [GPAReport]
    var title: String = "Marking Period GPAs"
    
    var groupedByYear: [(year: Int, gpas: [GPAReport])] {
        let grouped = Dictionary(grouping: markingPeriodGPAs) { $0.year }
        return grouped.map { (year: $0.key, gpas: $0.value) }
            .sorted { $0.year > $1.year }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.custom("ProductSans-Bold", size: 20))
                .foregroundColor(.secCol)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 20) {
                ForEach(groupedByYear, id: \.year) { yearGroup in
                    VStack(spacing: 12) {
                        Text(String(yearGroup.year) + "-" + String(yearGroup.year + 1))
                            .font(.custom("ProductSans-Bold", size: 16))
                            .foregroundColor(.secCol.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(yearGroup.gpas.sorted(by: { ($0.markingPeriod ?? 0) < ($1.markingPeriod ?? 0) })) { gpaReport in
                            if let mp = gpaReport.markingPeriod {
                                GPACard(
                                    title: "MP \(mp)",
                                    gpa: gpaReport.gpa,
                                    subtitle: "\(gpaReport.courseCount) courses",
                                    credits: gpaReport.totalCredits,
                                    courseCount: gpaReport.courseCount
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
}

struct YearlyGPASection: View {
    let yearlyGPAs: [GPAReport]
    var title: String = "Yearly GPAs"
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.custom("ProductSans-Bold", size: 20))
                .foregroundColor(.secCol)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(yearlyGPAs) { gpaReport in
                    GPACard(
                        title: String(gpaReport.year) + "-" + String(gpaReport.year + 1),
                        gpa: gpaReport.gpa,
                        subtitle: "Academic Year",
                        credits: gpaReport.totalCredits,
                        courseCount: gpaReport.courseCount
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GPACard: View {
    let title: String
    let gpa: Double
    let subtitle: String
    var credits: Double? = nil
    var courseCount: Int? = nil
    var isHighlighted: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("ProductSans-Bold", size: 18))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.custom("ProductSans-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                if let credits = credits, let count = courseCount {
                    Text("\(count) courses • \(String(format: "%.1f", credits)) credits")
                        .font(.custom("ProductSans-Regular", size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            Text(String(format: "%.4f", gpa))
                .font(.custom("ProductSans-Bold", size: isHighlighted ? 36 : 28))
                .foregroundColor(isHighlighted ? .terCol : .white)
        }
        .padding()
        .background(isHighlighted ? Color.terCol.opacity(0.2) : Color.black.opacity(0.3))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isHighlighted ? Color.terCol : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    ReportsView()
        .environmentObject(gradesViewModel())
}
