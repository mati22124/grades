//
//  ReportsViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 6/7/25.
//

import SwiftUI
import Combine

struct GPAReport: Identifiable {
    let id = UUID()
    let year: Int
    let markingPeriod: Int?
    let gpa: Double
    let totalCredits: Double
    let courseCount: Int
}

@MainActor
final class ReportsViewModel: ObservableObject {
    @Published var markingPeriodGPAs: [GPAReport] = []
    @Published var yearlyGPAs: [GPAReport] = []
    @Published var cumulativeGPA: Double = 0.0
    @Published var isLoading: Bool = true
    
    // Core GPA properties
    @Published var coreMarkingPeriodGPAs: [GPAReport] = []
    @Published var coreYearlyGPAs: [GPAReport] = []
    @Published var cumulativeCoreGPA: Double = 0.0
    
    // Unweighted GPA property
    @Published var cumulativeUnweightedGPA: Double = 0.0
    
    private var finalGradesVM = finalGradesViewModel()
    
    func calculateAllGPAs(courses: [course], userSettings: UserSettings?) {
        isLoading = true
        
        let finalGrades = finalGradesVM.finalGrades
        
        // Get all unique years
        let allYears = Set(courses.compactMap { $0.year } + finalGrades.map { $0.year }).sorted(by: >)
        
        var mpGPAs: [GPAReport] = []
        var yearGPAs: [GPAReport] = []
        
        for year in allYears {
            // Check if we have final grades for this year
            let yearFinalGrades = finalGrades.filter { $0.year == year }
            
            if !yearFinalGrades.isEmpty {
                // Use final grades for this year
                let yearGPA = calculateGPAFromFinalGrades(yearFinalGrades, settings: userSettings)
                yearGPAs.append(GPAReport(
                    year: year,
                    markingPeriod: nil,
                    gpa: yearGPA.gpa,
                    totalCredits: yearGPA.credits,
                    courseCount: yearFinalGrades.count
                ))
                
                // Calculate marking period GPAs from final grades
                let markingPeriods = Set(yearFinalGrades.compactMap { $0.markingPeriod }).sorted()
                for mp in markingPeriods {
                    let mpFinalGrades = yearFinalGrades.filter { $0.markingPeriod == mp }
                    let mpGPA = calculateGPAFromFinalGrades(mpFinalGrades, settings: userSettings)
                    mpGPAs.append(GPAReport(
                        year: year,
                        markingPeriod: mp,
                        gpa: mpGPA.gpa,
                        totalCredits: mpGPA.credits,
                        courseCount: mpFinalGrades.count
                    ))
                }
            } else {
                // Use regular courses for this year
                let yearCourses = courses.filter { $0.year == year }
                if !yearCourses.isEmpty {
                    // Group courses by name to find multi-marking period courses
                    let coursesByName = Dictionary(grouping: yearCourses) { $0.name }
                    
                    var yearWeightedGPA = 0.0
                    var yearTotalCredits = 0.0
                    
                    for (_, sameCourses) in coursesByName {
                        let credits = sameCourses.first?.credits ?? 5.0
                        let courseLevel = sameCourses.first?.courseLevel
                        
                        let letterGrade: String
                        if sameCourses.count > 1 {
                            // Multiple marking periods - average the letter grades
                            let letterGrades = sameCourses.map { $0.average.averageToGrade(settings: userSettings) }
                            letterGrade = averageLetterGrades(letterGrades)
                        } else if let course = sameCourses.first {
                            // Single marking period
                            letterGrade = course.average.averageToGrade(settings: userSettings)
                        } else {
                            continue
                        }
                        
                        let gpa = letterGrade.toGPA(courseLevel: courseLevel, settings: userSettings)
                        yearWeightedGPA += gpa * credits
                        yearTotalCredits += credits
                    }
                    
                    let yearGPA = yearTotalCredits > 0 ? yearWeightedGPA / yearTotalCredits : 0.0
                    yearGPAs.append(GPAReport(
                        year: year,
                        markingPeriod: nil,
                        gpa: yearGPA,
                        totalCredits: yearTotalCredits,
                        courseCount: coursesByName.count
                    ))
                    
                    // Calculate marking period GPAs
                    let markingPeriods = Set(yearCourses.compactMap { $0.markingPeriod }).sorted()
                    for mp in markingPeriods {
                        let mpCourses = yearCourses.filter { $0.markingPeriod == mp }
                        let mpGPA = calculateGPAFromCourses(mpCourses, settings: userSettings)
                        mpGPAs.append(GPAReport(
                            year: year,
                            markingPeriod: mp,
                            gpa: mpGPA.gpa,
                            totalCredits: mpGPA.credits,
                            courseCount: mpCourses.count
                        ))
                    }
                }
            }
        }
        
        // Update published properties
        self.markingPeriodGPAs = mpGPAs
        self.yearlyGPAs = yearGPAs
        
        // Calculate cumulative GPA
        calculateCumulativeGPA()
        
        // Calculate core GPAs
        calculateCoreGPAs(courses: courses, userSettings: userSettings)
        
        // Calculate unweighted GPA
        calculateUnweightedGPA(courses: courses, userSettings: userSettings)
        
        isLoading = false
    }
    
    private func calculateGPAFromFinalGrades(_ grades: [finalGrade], settings: UserSettings?) -> (gpa: Double, credits: Double) {
        var totalWeightedGPA = 0.0
        var totalCredits = 0.0
        
        for grade in grades {
            let gpa = grade.letterGrade.toGPA(courseLevel: grade.courseLevel, settings: settings)
            totalWeightedGPA += gpa * grade.credits
            totalCredits += grade.credits
        }
        
        let finalGPA = totalCredits > 0 ? totalWeightedGPA / totalCredits : 0.0
        return (finalGPA, totalCredits)
    }
    
    private func calculateGPAFromCourses(_ courses: [course], settings: UserSettings?) -> (gpa: Double, credits: Double) {
        var totalWeightedGPA = 0.0
        var totalCredits = 0.0
        
        for course in courses {
            let letterGrade = course.average.averageToGrade(settings: settings)
            let gpa = letterGrade.toGPA(courseLevel: course.courseLevel, settings: settings)
            let credits = course.credits ?? 5.0
            
            totalWeightedGPA += gpa * credits
            totalCredits += credits
        }
        
        let finalGPA = totalCredits > 0 ? totalWeightedGPA / totalCredits : 0.0
        return (finalGPA, totalCredits)
    }
    
    private func averageLetterGrades(_ grades: [String]) -> String {
        // Letter grade order from highest to lowest
        let gradeOrder = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
        
        // Get indices of all grades
        let indices = grades.compactMap { grade in
            gradeOrder.firstIndex(of: grade)
        }
        
        guard !indices.isEmpty else { return "F" }
        
        // Calculate average index
        let averageIndex = Double(indices.reduce(0, +)) / Double(indices.count)
        
        // Round up (which means lower index since higher grades have lower indices)
        let roundedIndex = Int(averageIndex.rounded(.down))
        
        // Ensure index is within bounds
        let finalIndex = max(0, min(roundedIndex, gradeOrder.count - 1))
        
        return gradeOrder[finalIndex]
    }
    
    private func calculateCumulativeGPA() {
        var totalWeightedGPA = 0.0
        var totalCredits = 0.0
        
        for yearGPA in yearlyGPAs {
            totalWeightedGPA += yearGPA.gpa * yearGPA.totalCredits
            totalCredits += yearGPA.totalCredits
        }
        
        cumulativeGPA = totalCredits > 0 ? totalWeightedGPA / totalCredits : 0.0
    }
    
    private func calculateCoreGPAs(courses: [course], userSettings: UserSettings?) {
        // Filter for core courses only
        let coreCourses = courses.filter { $0.isCore == true }
        let coreFinalGrades = finalGradesVM.finalGrades.filter { $0.isCore == true }
        
        // Get all unique years for core courses
        let allYears = Set(coreCourses.compactMap { $0.year } + coreFinalGrades.map { $0.year }).sorted(by: >)
        
        var coreMpGPAs: [GPAReport] = []
        var coreYearGPAs: [GPAReport] = []
        
        for year in allYears {
            // Check if we have core final grades for this year
            let yearCoreFinalGrades = coreFinalGrades.filter { $0.year == year }
            
            if !yearCoreFinalGrades.isEmpty {
                // Use final grades for this year
                let yearGPA = calculateGPAFromFinalGrades(yearCoreFinalGrades, settings: userSettings)
                coreYearGPAs.append(GPAReport(
                    year: year,
                    markingPeriod: nil,
                    gpa: yearGPA.gpa,
                    totalCredits: yearGPA.credits,
                    courseCount: yearCoreFinalGrades.count
                ))
                
                // Calculate marking period GPAs from final grades
                let markingPeriods = Set(yearCoreFinalGrades.compactMap { $0.markingPeriod }).sorted()
                for mp in markingPeriods {
                    let mpFinalGrades = yearCoreFinalGrades.filter { $0.markingPeriod == mp }
                    let mpGPA = calculateGPAFromFinalGrades(mpFinalGrades, settings: userSettings)
                    coreMpGPAs.append(GPAReport(
                        year: year,
                        markingPeriod: mp,
                        gpa: mpGPA.gpa,
                        totalCredits: mpGPA.credits,
                        courseCount: mpFinalGrades.count
                    ))
                }
            } else {
                // Use regular core courses for this year
                let yearCoreCourses = coreCourses.filter { $0.year == year }
                if !yearCoreCourses.isEmpty {
                    // Group courses by name to find multi-marking period courses
                    let coursesByName = Dictionary(grouping: yearCoreCourses) { $0.name }
                    
                    var yearWeightedGPA = 0.0
                    var yearTotalCredits = 0.0
                    
                    for (_, sameCourses) in coursesByName {
                        let credits = sameCourses.first?.credits ?? 5.0
                        let courseLevel = sameCourses.first?.courseLevel
                        
                        let letterGrade: String
                        if sameCourses.count > 1 {
                            // Multiple marking periods - average the letter grades
                            let letterGrades = sameCourses.map { $0.average.averageToGrade(settings: userSettings) }
                            letterGrade = averageLetterGrades(letterGrades)
                        } else if let course = sameCourses.first {
                            // Single marking period
                            letterGrade = course.average.averageToGrade(settings: userSettings)
                        } else {
                            continue
                        }
                        
                        let gpa = letterGrade.toGPA(courseLevel: courseLevel, settings: userSettings)
                        yearWeightedGPA += gpa * credits
                        yearTotalCredits += credits
                    }
                    
                    let yearGPA = yearTotalCredits > 0 ? yearWeightedGPA / yearTotalCredits : 0.0
                    coreYearGPAs.append(GPAReport(
                        year: year,
                        markingPeriod: nil,
                        gpa: yearGPA,
                        totalCredits: yearTotalCredits,
                        courseCount: coursesByName.count
                    ))
                    
                    // Calculate marking period GPAs
                    let markingPeriods = Set(yearCoreCourses.compactMap { $0.markingPeriod }).sorted()
                    for mp in markingPeriods {
                        let mpCourses = yearCoreCourses.filter { $0.markingPeriod == mp }
                        let mpGPA = calculateGPAFromCourses(mpCourses, settings: userSettings)
                        coreMpGPAs.append(GPAReport(
                            year: year,
                            markingPeriod: mp,
                            gpa: mpGPA.gpa,
                            totalCredits: mpGPA.credits,
                            courseCount: mpCourses.count
                        ))
                    }
                }
            }
        }
        
        // Update published properties
        self.coreMarkingPeriodGPAs = coreMpGPAs
        self.coreYearlyGPAs = coreYearGPAs
        
        // Calculate cumulative core GPA
        calculateCumulativeCoreGPA()
    }
    
    private func calculateCumulativeCoreGPA() {
        var totalWeightedGPA = 0.0
        var totalCredits = 0.0
        
        for yearGPA in coreYearlyGPAs {
            totalWeightedGPA += yearGPA.gpa * yearGPA.totalCredits
            totalCredits += yearGPA.totalCredits
        }
        
        cumulativeCoreGPA = totalCredits > 0 ? totalWeightedGPA / totalCredits : 0.0
    }
    
    private func calculateUnweightedGPA(courses: [course], userSettings: UserSettings?) {
        let finalGrades = finalGradesVM.finalGrades
        var totalWeightedGPA = 0.0
        var totalCredits = 0.0
        
        // Get all unique years
        let allYears = Set(courses.compactMap { $0.year } + finalGrades.map { $0.year }).sorted(by: >)
        
        for year in allYears {
            // Check if we have final grades for this year
            let yearFinalGrades = finalGrades.filter { $0.year == year }
            
            if !yearFinalGrades.isEmpty {
                // Use final grades for this year (unweighted - treat as CP)
                for grade in yearFinalGrades {
                    let gpa = grade.letterGrade.toGPA(courseLevel: .CP, settings: userSettings)
                    totalWeightedGPA += gpa * grade.credits
                    totalCredits += grade.credits
                }
            } else {
                // Use regular courses for this year
                let yearCourses = courses.filter { $0.year == year }
                
                // Group courses by name to find multi-marking period courses
                let coursesByName = Dictionary(grouping: yearCourses) { $0.name }
                
                for (_, sameCourses) in coursesByName {
                    let credits = sameCourses.first?.credits ?? 5.0
                    
                    let letterGrade: String
                    if sameCourses.count > 1 {
                        // Multiple marking periods - average the letter grades
                        let letterGrades = sameCourses.map { $0.average.averageToGrade(settings: userSettings) }
                        letterGrade = averageLetterGrades(letterGrades)
                    } else if let course = sameCourses.first {
                        // Single marking period
                        letterGrade = course.average.averageToGrade(settings: userSettings)
                    } else {
                        continue
                    }
                    
                    // Always use CP weight for unweighted GPA
                    let gpa = letterGrade.toGPA(courseLevel: .CP, settings: userSettings)
                    totalWeightedGPA += gpa * credits
                    totalCredits += credits
                }
            }
        }
        
        cumulativeUnweightedGPA = totalCredits > 0 ? totalWeightedGPA / totalCredits : 0.0
    }
}