//
//  importManager.swift
//  grades
//
//  Created by Mayank Tiku on 11/19/24.
//

import SwiftUI
import SwiftAnthropic

final class importManager {
    static let shared = importManager()
    
    init() {}
    
    func sendMessageFromImage(image: UIImage?) async throws -> [grade] {
        // Setup anthropic
        let apiKey = "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"
        let service = AnthropicServiceFactory.service(apiKey: apiKey, betaHeaders: nil)
        let maxTokens = 1024
        
        // Make sure the image exists and convert to base64
        guard let realImage = image else {
            throw importError.noImage
        }
        let base64Image = realImage.base64
        guard let base64Real = base64Image else {
            throw importError.noImage
        }
        
        // Create image paramater based on anthropic
        let imageSource: [MessageParameter.Message.Content.ContentObject] = [.image(.init(type: .base64, mediaType: .jpeg, data: base64Real))]
        let messagesParameter = [MessageParameter.Message(role: .user, content: .list(imageSource))]

        // Create prompt
        let parameters = MessageParameter(model: .claude3Haiku, messages: messagesParameter, maxTokens: maxTokens, system: .list([.init(text: "can you take this image and parse the Title, points earned, points total, date, and weight (default 1) and separate each by a comma. The format should be \"Title,earned,total,date,weight\". Each seperate grade should be seperated by a # symbol. no square brackets. the date should be in the format dd/MM/yyyy. All places should be filled. That means to include 0's if they are missing. Make sure the day of the month conforms to the year it is supposed to be. it is important that the year matches the correct day of the week. PLEASE LOOK AT THE DAY OF THE WEEK ABOVE THE DATE AND MAKE SURE IT MATCHES WITH A FUTURE YEAR. The school year is 2024-2025 currently. the percentage is not required in the json AT ALL. ONLY RESPOND WITH THE LIST OF GRADES OBJECTS WITHOUT SQUARE BRACKETS. The name does not need double quotes around it. respond with no new line breaks and no spaces. if you do not understand the photo or there aren't a clear list of grades, return an empty list. If the photo does not contain a very obvious list of grades, return an empty string.", cacheControl: nil)]), temperature: 0)

        // Ask Claude for prompt
        print("about to prompt")
        let message = try await service.createMessage(parameters)
        print("got prompt back and attempting to parse")
        
        // Parse String from message
        var strList = ""
        if let data = message.content.first {
            print("this is data: \(data)")
            switch(data) {
            case .text(let str):
                strList = str
            default:
                print("could not parse the text")
                throw importError.cantParse
            }
        }
        print("string parsed: \(strList)"+"\n\n")
        
        if strList.isEmpty || !strList.contains("#"){
            throw importError.nothingInImage
        }
        
        // Get list from message
        let gradesList = strList.split(separator: "#")
        var parsedGrades: [grade] = []
        for i in gradesList {
            let x = i.split(separator: ",")
            parsedGrades.append(grade(name: String(x[0]), points: Double(x[2]) ?? 1, earned: Double(x[1]) ?? 0, weight: Double(x[4]) ?? 1, datee: String(x[3])))
        }
        
        return parsedGrades
    }

}

enum importError: Error {
    case cantParse
    case noGrades
    case noImage
    case nothingInImage
}
