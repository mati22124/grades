//
//  WebView.swift
//  grades
//
//  Created by Mayank Tiku on 12/17/24.
//

import SwiftUI
import WebKit
import SwiftSoup

class MyWKDelegate: NSObject, WKNavigationDelegate {
    var onGradesReceived: ((course?) -> Void)?
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        webView.evaluateJavaScript("document.documentElement.innerHTML") { result, error in
            if let datHtml = result as? String {
                
                do {
                    let cours = try importGenesisViewModel.shared.parseHTML(html: datHtml)
                    self.onGradesReceived?(cours)
                    print("have run on grades recieved")
//                    let doc = try SwiftSoup.parse(datHtml)
//                    
//                    // Find the course selector and get the selected option
//
//                    
//                    // Find all table rows that contain grade information
//                    let rows = try doc.select("tr.listroweven, tr.listrowodd").array()
//                    
//                    var grades: [grade] = []
//                    var x = 1
//                    for row in rows {
//                        let cells = try row.select("td").array()
//                        if cells.count >= 7 { // Ensure we have enough cells
//                            if x<5 {
//                                var t = 0
//                                for i in cells {
//                                    print("INDEX "+String(t))
//                                    print(try i.text())
//                                    t+=1
//                                }
//                                x+=1
//                            }
//                            
//                            // Extract date
//                            let dateDiv = try cells[0].select("div").array()
//                            var comps = DateComponents()
//                            if dateDiv.count >= 2 {
//                                let dayOfWeek =  "\(try dateDiv[0].text())"
//                                let dateTot = "\(try dateDiv[1].text())"
//                                
//                                let datearr = dateTot.split(separator: "/")
//                                comps.month = Int(datearr[0])
//                                comps.day = Int(datearr[1])
//                                comps.year = self.findClosestYear(month: comps.month!, day: comps.day!, dayOfWeek: dayOfWeek.strTodowNum())
//                            }
//                            
//                            
//                            // Extract name info from second cell
//                            let name = try cells[3].text()
//                            
//                            // Extract assignment info from second cell
//                            var categoryCell = try cells[1].text()
//                            categoryCell = "teouh"+categoryCell
//                                                        
//                            let category = categoryCell.components(separatedBy: name)[1].trimmingCharacters(in: .whitespaces)
//                            
//                            // Extract grade info from third cell
//                            var score = 0.0
//                            var toal = 0.0
//                            let gradeText = try cells[6].text()
//                            if let range = gradeText.range(of: #".+\s*/\s*\d+"#, options: .regularExpression) {
//                                let trimmedArray = String(gradeText[range]).split(separator: " ")
//                                if trimmedArray.count>=3 {
//                                    score = Double(trimmedArray[0]) ?? 0.0
//                                    toal = Double(trimmedArray[2]) ?? 0.0
//                                }
//                            }
//                            let grade = grade(name: name, points: toal, earned: score, weight: 1, date: Calendar.current.date(from: comps)!, category: category)
//                            grades.append(grade)
//                        }
//                    }
//                    
//                    // Print the extracted grades
//                    for grade in grades {
//                        print("Date: \(grade.date)")
//                        print("Assignment: \(grade.name)")
//                        print("Category: \(grade.category ?? "no cat")")
//                        print("Points: \(grade.earned)/\(grade.points)")
//                        print("---")
//                    }
                    
                } catch Exception.Error(let type, let message) {
                    print("Error type: \(type), Message: \(message)")
                } catch {
                    print("Error parsing HTML")
                }
            }
        }
    }

}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

@MainActor
class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL
    let delegate = MyWKDelegate()
    
    @Published var anim: Bool = false
    
    @Published var ccc: [course] = []
    
    init() {
        webView = WKWebView(frame: .zero)
        url = URL(string: "https://students.livingston.org/")!
        
        delegate.onGradesReceived = { crr in
            Task {
                print("grades recieved")
                if let x = crr {
                    if !self.ccc.contains(where: { $0.name == x.name }) {
                        self.ccc.append(x)
                        self.anim = true
                        try await Task.sleep(nanoseconds: 1000000000)
                        self.anim = false
                    }
                }
            }
        }
        
        webView.navigationDelegate = delegate

        loadUrl()
    }
    
    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
    
//    func ifNewCourse(/*completion: @escaping (_ t: course) -> Void*/) {
//
//    }
}
