//
//  DateFunctions.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import UIKit

extension Date {
    
    func formattedMonthDayYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy"
        return dateFormatter.string(from: self)
    }
    
}

class Utils {
    
    static func convertSingleImageToData(_ image: UIImage?) -> Data? {
        guard let dataImage = image else { return nil }
        return dataImage.jpegData(compressionQuality: 1.0)
    }
    
    static func generateRandomEntries() -> [JournalEntry] {
        var entries: [JournalEntry] = []

        for quote in Constants.quotes {
            let date = generateRandomDateInRange()
            let summary = quote
            let photoData = Utils.convertSingleImageToData(UIImage(imageLiteralResourceName: "placeholder"))
            let relatedPhotosData = generateRelatedPhotosData()
            let tags: [String] = generateRandomTags()
            let needToShowTags = Bool.random()
            
            let entry = JournalEntry(date: date, summary: summary, photoData: photoData, relatedPhotosData: relatedPhotosData, tags: tags, needToShowTags: needToShowTags)
            entries.append(entry)
        }
        
        return entries
    }
    
    static func generateRandomDateInRange() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: currentDate) else {
            return Date()
        }
        
        let randomTimeInterval = TimeInterval.random(in: oneYearAgo.timeIntervalSince1970...currentDate.timeIntervalSince1970)
        return Date(timeIntervalSince1970: randomTimeInterval)
    }
    
    static func generateRelatedPhotosData() -> [Data] {
        // Placeholder images
        let placeholderNames = ["placeholder", "placeholder1", "placeholder2"]
        var relatedPhotosData: [Data] = []
        
        // Generate random related photos data
        for _ in 0..<3 {
            if let image = UIImage(named: placeholderNames.randomElement()!) {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    relatedPhotosData.append(imageData)
                }
            }
        }
        
        return relatedPhotosData
    }
    
    static func generateRandomTags() -> [String] {
        let numberOfTags = Int.random(in: 0...3) // Generate up to 3 random tags
        var tags: [String] = []

        // Select random tags
        for _ in 0..<numberOfTags {
            if let tag = Constants.possibleTags.randomElement() {
                tags.append(tag)
            }
        }

        return tags
    }
    
}
