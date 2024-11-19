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
        let imageSource: [MessageParameter.Message.Content.ContentObject] = [
            .image(.init(type: .base64, mediaType: .jpeg, data: base64Real)),
            .text("""
You will be given an image of a grade report. Your task is to parse the information from this image and format it according to specific requirements.
Analyze the image and extract the following information for each grade entry:
- Title
- Points earned
- Points total
- Date
- Weight (default to 1 if not specified)

Format each grade entry as follows: "Title,earned,total,date,weight"

Follow these guidelines:
1. The title is typically bolded in the image and resides under the category.
2. Convert the date to the format dd/MM/yyyy.
3. Ensure all fields are filled. Use 0 if a value is missing.
4. The school year is 2024-2025. Adjust the year in the date to match this and ensure it corresponds to the correct day of the week shown in the image.
5. Do not include the percentage in the output.
6. Separate each grade entry with a # symbol.

Important notes:
- Do not use quotation marks around the title.
- Do not include any new line breaks or spaces in the output.
- If the image does not contain a clear list of grades or is unclear, return an empty string.

Provide your output as a single line of text with no additional commentary. The output should only contain the formatted grade entries or be empty if no clear grades are present.
""") //this is the long ahh prompt
        ]
        let messagesParameter = [MessageParameter.Message(role: .user, content: .list(imageSource))]

        // Create prompt
        let parameters = MessageParameter(model: .claude3Haiku, messages: messagesParameter, maxTokens: maxTokens, temperature: 0.2)

        // Ask Claude for prompt
        print("about to prompt")
        let message = try await service.createMessage(parameters)
        print("got prompt back and attempting to parse")
        
        
        // Parse String from message
        var strList = ""
        if let data = message.content.first {
            print(data)
            switch(data) {
            case .text(let str):
                strList = str
            default:
                print("could not parse the text")
                throw importError.cantParse
            }
        }
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
