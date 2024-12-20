//
//  importViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 12/19/24.
//

import Foundation
import SwiftSoup

@MainActor
class importGenesisViewModel: ObservableObject {
    static let shared = importGenesisViewModel()
    private init() {}
        
    func parseHTML(html: String) throws -> course? {
        let doc = try SwiftSoup.parse(html)
        
        let courseName = try parseTitle(doc)
        
        // Find all table rows that contain grade information
        let rows = try doc.select("tr.listroweven, tr.listrowodd").array()
        
        var grades: [grade] = []
        
        // iterate through each row
        for row in rows {
            // find just all the cells before parsing
            let cells = try row.select("td").array()
            if cells.count >= 7 {
                
                let date = try parseDate(cells)
                let (name, category) = try parseNameCateg(cells)
                let (earned, total) = try parsePoints(cells)
                
                // add to list
                let grade = grade(name: name, points: total, earned: earned, weight: 1, date: date, category: category)
                grades.append(grade)
            }
        }
        print(grades)
        if grades.isEmpty {
            return nil
        }
        return course(name: courseName, teacher: "", isPoints: true, grades: grades)
    }
    
    private func parseDate(_ cells: [Element]) throws -> Date {
        let dateDiv = try cells[0].select("div").array()
        var comps = DateComponents()
        if dateDiv.count >= 2 {
            let dayOfWeek =  "\(try dateDiv[0].text())"
            let dateTot = "\(try dateDiv[1].text())"
            
            let datearr = dateTot.split(separator: "/")
            if datearr.count >= 2 {
                comps.month = Int(datearr[0])
                comps.day = Int(datearr[1])
                comps.year = self.findClosestYear(month: comps.month!, day: comps.day!, dayOfWeek: dayOfWeek.strTodowNum())
            }
        }
        return Calendar.current.date(from: comps)!
    }
    
    private func parseTitle(_ doc: Document) throws -> String {
        let courseSelect = try doc.select("select#fldCourse").first()
        let selectedCourse = try courseSelect?.select("option[selected]").first()
        let courseName = try selectedCourse?.text() ?? ""
        return courseName
    }
    
    private func parseNameCateg(_ cells: [Element]) throws -> (String, String) {
        // Extract name info from second cell
        let name = try cells[3].text()
        
        // Extract assignment info from second cell
        var categoryCell = try cells[1].text()
        categoryCell = "teouh"+categoryCell
        
        let category = categoryCell.components(separatedBy: name)[1].trimmingCharacters(in: .whitespaces)
        return (name, category)
    }
    
    private func parsePoints(_ cells: [Element]) throws -> (Double, Double) {
        var score = 0.0
        var toal = 0.0
        let gradeText = try cells[6].text()
        let trimmedArray = String(gradeText).split(separator: "/")
        if trimmedArray.count>=2 {
            let earn = trimmedArray[0]
            let total = trimmedArray[1].trimmingCharacters(in: .whitespaces)
            print(earn)
            
            if let range = earn.range(of: #"\S+\s*\z"#, options: .regularExpression) {
                score = Double(earn[range].trimmingCharacters(in: .whitespaces)) ?? 0.0
            }
            
            if let r = total.range(of: #"\A\d+(\.*\d+)?"#, options: .regularExpression) {
                toal = Double(total[r]) ?? 0.0
            }
        }
        
        return (score, toal)
    }
    
    private func findClosestYear(month: Int, day: Int, dayOfWeek: Int, searchRange: Int = 50) -> Int? {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        
        // Search both backwards and forwards from current year
        var closestYear: Int?
        var smallestDiff = Int.max
        
        for year in (currentYear - searchRange)...(currentYear + searchRange) {
            dateComponents.year = year
            
            if let date = calendar.date(from: dateComponents),
               let weekday = calendar.dateComponents([.weekday], from: date).weekday,
               weekday == dayOfWeek {
                
                let diff = abs(year - currentYear)
                if diff < smallestDiff {
                    smallestDiff = diff
                    closestYear = year
                }
            }
        }
        
        return closestYear
    }
}
