//
//  URLHandler.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import Foundation

class URLHandler {
    
    static let urlString = "https://type.fit/api/quotes"
    
    // Fetch data from the URL and parse it
    static func fetchData(completion: @escaping ([String]) -> Void) {
        // Create a URL object from the urlString
        guard let url = URL(string: URLHandler.urlString) else {
            print("Invalid URL")
            completion([])
            return
        }
        
        // Create a URLSession task to fetch data from the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error fetching data: \(error)")
                completion([])
                return
            }
            
            // Ensure there is data
            guard let data = data else {
                print("No data returned")
                completion([])
                return
            }
            
            do {
                // Decode the JSON data into an array of dictionaries
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                
                // Extract the text from each quote dictionary
                let texts = quotes.map { $0.text }
                
                // Call the completion handler with the extracted texts
                completion(texts)
            } catch {
                print("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}

struct Quote: Codable {
    let text: String
    let author: String
}
