//
//  autoImportViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/4/25.
//

import Foundation
import Alamofire
import SwiftSoup

class autoImportViewModel: ObservableObject {
    
    var sessionId: String?
    var studentId: String?
    
    func authenticate(baseURL: String, username: String, password: String) async throws {
        sessionId = nil
        studentId = nil
        let authURL = "\(baseURL)/sis/j_security_check"
        
        // Parse the host from base URL
        guard let url = URL(string: baseURL),
              let host = url.host else {
            throw AuthenticationError.authenticationFailed("Invalid base URL")
        }
        
        // Prepare headers
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Cache-Control": "max-age=0",
            "Dnt": "1",
            "Host": host,
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
        ]
        
        // Prepare form data
        let parameters = [
            "idTokenString": "",
            "j_username": username,
            "j_password": password
        ]
        
        // Create a custom redirect handler that doesn't follow redirects
        let redirectHandler = Redirector(behavior: .doNotFollow)
        
        // First request - authenticate
        let authResponse = await AF.request(authURL,
                                            method: .post,
                                            parameters: parameters,
                                            encoder: URLEncodedFormParameterEncoder.default,
                                            headers: headers)
            .redirect(using: redirectHandler)
            .validate(statusCode: 200..<400)
            .serializingResponse(using: .data)
            .response
        
        guard let httpResponse = authResponse.response else {
            throw AuthenticationError.invalidResponse
        }
        
        // Extract JSESSIONID from cookies
        guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: authURL)!),
              let jsessionId = cookies.first(where: { $0.name == "JSESSIONID" })?.value else {
            throw AuthenticationError.authenticationFailed("Authentication failed. Please check your credentials.")
        }
        
        // Get redirect location from first response
        guard let location = httpResponse.allHeaderFields["Location"] as? String else {
            throw AuthenticationError.authenticationFailed("No redirect location found. Make sure your credentials are correct and try again.")
        }
        
        // Create cookie header for next request
        let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
        var redirectHeaders = headers
        for (key, value) in cookieHeader {
            redirectHeaders.add(name: key, value: value)
        }
        
        // Second request - follow the redirect manually
        let redirectResponse = await AF.request(location,
                                                method: .get,
                                                headers: redirectHeaders)
            .redirect(using: redirectHandler)
            .serializingResponse(using: .data)
            .response
        
        guard let redirectHttpResponse = redirectResponse.response else {
            throw AuthenticationError.invalidResponse
        }
        
        // Get the final redirect location
        guard let finalLocation = redirectHttpResponse.allHeaderFields["Location"] as? String else {
            throw AuthenticationError.authenticationFailed("No student ID redirect found")
        }
        
        // Parse student ID from query parameters
        guard let redirectURL = URL(string: finalLocation),
              let components = URLComponents(url: redirectURL, resolvingAgainstBaseURL: false),
              let studentId = components.queryItems?.first(where: { $0.name == "studentid" })?.value else {
            throw AuthenticationError.authenticationFailed("Student ID not found in redirect. check if your email is correct.")
        }
        
        if studentId.isEmpty { throw AuthenticationError.authenticationFailed("Student ID is empty") }
        
        sessionId = jsessionId
        self.studentId = studentId
        print("auth successful!")
    }
    
    private func getGradebookHTML(baseURL: String) async throws -> String {
        guard let sessionId = sessionId else {
            throw AuthenticationError.authenticationFailed("Not logged in. please authenticate first")
        }
        
        guard let studentId = studentId else {
            throw AuthenticationError.authenticationFailed("Not logged in. please authenticate first")
        }
        let url = "\(baseURL)/parents"
        
        // Parse the host from base URL
        guard let parsedURL = URL(string: baseURL),
              let host = parsedURL.host else {
            throw AuthenticationError.networkError("Invalid base URL")
        }
        
        // Prepare query parameters
        let parameters: [String: String] = [
            "tab1": "studentdata",
            "tab2": "gradebook",
            "tab3": "weeklysummary",
            "action": "form",
            "studentid": studentId
        ]
        
        // Prepare headers
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Cache-Control": "max-age=0",
            "Dnt": "1",
            "Host": host,
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
            "Cookie": "JSESSIONID=\(sessionId)"
        ]
        
        // Make the request
        let response = await AF.request(url,
                                        method: .get,
                                        parameters: parameters,
                                        encoding: URLEncoding.default,
                                        headers: headers)
            .validate(statusCode: 200..<300)
            .serializingString()
            .response
        
        switch response.result {
        case .success(let html):
            return html
        case .failure(let error):
            throw AuthenticationError.networkError("Failed to fetch day HTML: \(error.localizedDescription)")
        }
    }
    
    func getTempCourses(baseURL: String) async throws -> [tempCourse] {
        let html = try await getGradebookHTML(baseURL: baseURL)
        let doc: Document = try SwiftSoup.parse(html)
        var courses: [tempCourse] = []
        
        // Find all course containers (divs with colored borders that contain course information)
        let courseContainers = try doc.select("div[style*='border: 3pt solid']")
        
        for container in courseContainers {
            // Get the course header div
            guard let headerDiv = try container.select("div[style*='background-color']").first() else {
                continue
            }
            
            // Extract course information from onclick attribute
            var courseName = ""
            var courseCode = ""
            var section = ""
            
            let spans = try headerDiv.select("span[onclick]")
            for span in spans {
                let onclick = try span.attr("onclick")
                if onclick.contains("goToCourseSummary") {
                    // Extract parameters from goToCourseSummary('045-1','8','MP1')
                    let regex = try NSRegularExpression(pattern: "goToCourseSummary\\('([^']+)','([^']+)','([^']+)'\\)", options: [])
                    let nsString = onclick as NSString
                    let results = regex.matches(in: onclick, options: [], range: NSRange(location: 0, length: nsString.length))
                    
                    if let match = results.first, match.numberOfRanges == 4 {
                        courseCode = nsString.substring(with: match.range(at: 1))
                        section = nsString.substring(with: match.range(at: 2))
                        courseName = try span.text().trimmingCharacters(in: .whitespaces)
                        break
                    }
                }
            }
            
            // Skip if we couldn't extract basic course info
            if courseName.isEmpty || courseCode.isEmpty {
                continue
            }
            
            // Extract teacher name
            var teacher = ""
            let teacherDivs = try headerDiv.select("div[style*='font-style: oblique']")
            for div in teacherDivs {
                let text = try div.text()
                // Remove leading whitespace/nbsp and clean up
                let cleanText = text.replacingOccurrences(of: "\u{00A0}", with: " ") // Replace &nbsp;
                                  .trimmingCharacters(in: CharacterSet.whitespaces)
                
                if cleanText.count > 3 {
                    teacher = String(cleanText).trimmingCharacters(in: .whitespaces)
                    break
                }
            }
            
            // Extract possible marking periods
            var possibleMP: [String] = []
            
            // Find the table with marking period information
            if let table = try container.select("table").first() {
                let rows = try table.select("tr")
                if rows.count >= 1 {
                    // First row contains marking period names
                    let headerCells = try rows[0].select("td")
                    
                    for cell in headerCells {
                        let headerText = try cell.text().trimmingCharacters(in: CharacterSet.whitespaces)
                        
                        // Extract MP number from text like "MP1" or "MP2"
                        let mp = headerText.split(separator: " ").first
                        if let mp = mp {
                            possibleMP.append(String(mp))
                        }
                    }
                }
            }
            
            // Create unique ID from course code and section
            let id = "\(courseCode)-\(section)"
            
            // Create the course object
            for i in possibleMP {
                let course = tempCourse(
                    name: courseName,
                    teacher: teacher,
                    courseCode: courseCode,
                    section: section,
                    id: id,
                    MP: i
                )
                courses.append(course)
            }
            
        }
        
        return courses
    }
    
    func getCourseHTML(baseURL: String, courseCode: String, courseSection: String, markingPeriod: String) async throws -> String {
        guard let sessionId = sessionId else {
            throw AuthenticationError.authenticationFailed("Not logged in. please authenticate first")
        }
        
        guard let studentId = studentId else {
            throw AuthenticationError.authenticationFailed("Not logged in. please authenticate first")
        }
        let url = "\(baseURL)/parents"
        
        // Parse the host from base URL
        guard let parsedURL = URL(string: baseURL),
              let host = parsedURL.host else {
            throw AuthenticationError.networkError("Invalid base URL")
        }
        
        // Prepare query parameters
        let parameters: [String: String] = [
            "tab1": "studentdata",
            "tab2": "gradebook",
            "tab3": "coursesummary",
            "action": "form",
            "studentid": studentId,
            "courseCode": courseCode,
            "courseSection": courseSection,
            "mp": markingPeriod
        ]
        
        // Prepare headers
        let headers: HTTPHeaders = [
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Cache-Control": "max-age=0",
            "Dnt": "1",
            "Host": host,
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
            "Cookie": "JSESSIONID=\(sessionId)"
        ]
        
        // Make the request
        let response = await AF.request(url,
                                        method: .get,
                                        parameters: parameters,
                                        encoding: URLEncoding.default,
                                        headers: headers)
            .validate(statusCode: 200..<300)
            .serializingString()
            .response
        
        switch response.result {
        case .success(let html):
            return html
        case .failure(let error):
            throw AuthenticationError.networkError("Failed to fetch day HTML: \(error.localizedDescription)")
        }
    }
    
    func parseCourseHTML(html: String) throws -> course? {
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
                let (name, category, weight) = try parseNameCateg(cells)
                let (earned, total) = try parsePoints(cells)
                
                // add to list
                let grade = grade(name: name, points: total, earned: earned, weight: weight, date: date, category: category)
                grades.append(grade)
            }
        }
        var cat = try parseCategories(doc)
//        print(cat)
        
        // if didnt parse anything
        if grades.isEmpty {
            return nil
        }
        
        //if its not caregoy weighted
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
}

// all of these are helper functions.
extension autoImportViewModel {
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
    
    private func parseNameCateg(_ cells: [Element]) throws -> (String, String, Double) {
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
        
        var weight = 1.0
        do {
            if let weightDiv = try cells[6].select("div[title*='Assignment Weight']").first() {
                let weightText = try weightDiv.text()
                if weightText.hasPrefix("x") {
                    let numberText = weightText.dropFirst() // Remove the 'x'
                    weight = Double(numberText) ?? 1.0
                }
            }
        } catch {
            print("error parsing weight: \(error)")
        }
        
        return (name, category, weight)
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
                        score = 0.78*toal
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
