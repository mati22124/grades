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
        var cat = try parseCategories(doc)
        print(cat)
        
        // if didnt parse anything
        if grades.isEmpty {
            return nil
        }
        
        //if its caregoy weighted
        if cat.isEmpty {
            return course(name: courseName, teacher: "", isPoints: true, grades: grades)
        }
        
        for (ind, i) in cat.enumerated() {
            for j in grades {
                if j.category == i.name {
                    cat[ind].grades.append(j)
                }
            }
        }
        
        return course(name: courseName, teacher: "", grades: grades, categories: cat)
    }
    
    private func parseDate(_ cells: [Element]) throws -> Date {
        do {
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
                } else {
                    return Date()
                }
            }
            return Calendar.current.date(from: comps)!
            
        } catch {
            print("some error happeded when tryna find the date: \(error)")
            return Date()
        }
    }
    
    private func parseTitle(_ doc: Document) throws -> String {
        let courseSelect = try doc.select("select#fldCourse").first()
        let selectedCourse = try courseSelect?.select("option[selected]").first()
        let courseName = try selectedCourse?.text().capitalized ?? ""
        let tempList = courseName.split(separator: " ")
        var cname = ""
        for i in tempList {
            if i.count <= 2 {
                cname+=i.uppercased()+" "
            } else {
                cname+=i+" "
            }
        }
        return cname
    }
    
    private func parseNameCateg(_ cells: [Element]) throws -> (String, String) {
        // Extract name info from second cell
        var name = "Unknown"
        do {
            name = try cells[3].text()
        } catch {
            print("error parsing name: \(error)")
        }
        
        // Extract assignment info from second cell
        var category = "No Category"
        do {
            if let temp = try cells[1].select("div[style*=italic]").first() {
                category = try temp.text()
            }
        } catch {
            print("error parsing category: \(error)")
        }
        
        return (name, category)
    }
    
    private func parsePoints(_ cells: [Element]) throws -> (Double, Double) {
        var score = 0.0
        var toal = 0.0
        do {
            let gradeText = try cells[6].text()
            let trimmedArray = String(gradeText).split(separator: "/")
            if trimmedArray.count>=2 {
                let earn = trimmedArray[0]
                let total = trimmedArray[1].trimmingCharacters(in: .whitespaces)
                
                // IF right side is a point
                if let r = total.range(of: #"\A\d+(\.*\d+)?"#, options: .regularExpression) {
                    toal = Double(total[r]) ?? 0.0
                }
                
                // IF THE LEFT SIDE IS CHECK++ OR ETC
                if let range = earn.range(of: #"\S+\s*\z"#, options: .regularExpression) {
                    let tstr = earn[range].trimmingCharacters(in: .whitespaces)
                    if let s = Double(tstr) {
                        score = s
                    } else if tstr == "CHECKPLUSPLUS" {
                        score = toal
                    } else if tstr == "CHECKPLUS" {
                        score = 0.85*toal
                    } else if tstr == "CHECK" {
                        score = 0.7*toal
                    } else if tstr == "A+" {
                        score = 0.975*toal
                    } else if tstr == "A" {
                        score = 0.965*toal
                    } else if tstr == "A-" {
                        score = 0.915*toal
                    } else if tstr == "B+" {
                        score = 0.885*toal
                    } else if tstr == "B" {
                        score = 0.85*toal
                    } else if tstr == "B-" {
                        score = 0.815*toal
                    } else if tstr == "C+" {
                        score = 0.785*toal
                    } else if tstr == "C" {
                        score = 0.75*toal
                    } else if tstr == "C-" {
                        score = 0.715*toal
                    } else if tstr == "D+" {
                        score = 0.685*toal
                    } else if tstr == "D" {
                        score = 0.65*toal
                    } else if tstr == "D-" {
                        score = 0.615*toal
                    } else/* if tstr == "F"*/ {
                        score = 0.6*toal
                    }
                }
            }
        } catch {
            print("error parsing points/earned: \(error)")
        }
        
        return (score, toal)
    }
    
    private func parseCategories(_ doc: Document) throws -> [category] {
        var categories: [category] = []
        
        if let categoryTable = try doc.select("table.list").filter({ try $0.text().contains("Grading Information") }).first {
            let categoryRows = try categoryTable.select("tr:has(td.cellLeft > b)").array()
            
            for row in categoryRows {
                let cells = try row.select("td").array()
                if cells.count >= 2 {
                    let categoryName = try cells[0]/*.select("b")*/.text()
                    let wt = try cells[1].text()
                    if !wt.contains("%") { continue }
                    let weightText = wt.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
                    if let weight = Double(weightText) {
                        categories.append(category(name: categoryName, grades: [], weight: weight/100.0))
                    }
                }
            }
        }
        return categories
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
