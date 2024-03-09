//
//  CustomListElement.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import SwiftUI

struct CustomListElement: View {
    
    let date: Date
    let summary: String
    let photo: UIImage?
    let tags: [String]
    let needToShowTags: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date.formattedMonthDayYear())
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(summary)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
            if let photo = photo {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            if needToShowTags == true && !tags.isEmpty {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        TagView(tag: tag)
                    }
                }
            }
        }
        .padding(10)
    }
}

#Preview {
    CustomListElement(date: Date(), summary: "Inspirational quote of the day, March 8", photo: UIImage(named: "placeholder"), tags: ["love","peace"], needToShowTags: true)
}
