//
//  JurnalEntry.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import UIKit

struct JournalEntry: Identifiable, Hashable, Codable {
    let id = UUID()
    let date: Date
    let summary: String
    let photoData: Data?
    let relatedPhotosData: [Data]?
    let tags: [String]
    let needToShowTags: Bool
    
    // Computed property to convert photoData back to UIImage
    var photo: UIImage? {
        guard let data = photoData else { return nil }
        return UIImage(data: data)
    }
    
    // Computed property to convert relatedPhotosData back to [UIImage]
    var relatedPhotos: [UIImage]? {
        guard let data = relatedPhotosData else { return nil }
        return data.compactMap { UIImage(data: $0) }
    }

}
