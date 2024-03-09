//
//  JournalViewModel.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import Foundation
import UIKit
import Combine

class JournalListViewModel: ObservableObject {
    
    @Published var entries: [JournalEntry] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $entries
            .sink { [weak self] _ in
                self?.saveEntries() // Save entries whenever they change
            }
            .store(in: &cancellables)
    
    }
    
    // Load entries from UserDefaults
    func fetchEntries(completion: @escaping () -> Void) {
        if !UserDefaults.standard.bool(forKey: Constants.needToFetchKey) {
            self.entries = Utils.generateRandomEntries()
            self.saveEntries()
            UserDefaults.standard.set(true,forKey: Constants.needToFetchKey)
            // Delaying to mimmik request
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion()
            }

        } else {
            if let data = UserDefaults.standard.data(forKey: Constants.journalEntriesKey) {
                do {
                    // Decode data into entries array
                    entries = try JSONDecoder().decode([JournalEntry].self, from: data)
                    completion()
                } catch {
                    print("Error decoding entries: \(error)")
                    completion()
                }
            }
        }

    // Half-solution for requests
//        URLHandler.fetchData { quotes in
//            DispatchQueue.main.async {
//                var updatedEntries: [JournalEntry] = []
//
//                // Iterate over fetched quotes and create new JournalEntry instances
//                for quote in quotes {
//                    let newEntry = JournalEntry(date: Date(), summary: quote, photoData: Utils.convertSingleImageToData(UIImage(imageLiteralResourceName: "placeholder")), relatedPhotosData: nil, tags: [], needToShowTags: false)
//                    updatedEntries.append(newEntry)
//                }
//                updatedEntries = Utils.generateRandomEntries(quotes: quotes)
//                // Replace the current entries with the updated entries
//                self.entries = updatedEntries
//
//                // Save or encode the updated entries if necessary
//                self.saveEntries()
//                completion()
//            }
//        }
        

    }
    
    // Save entries to UserDefaults
    private func saveEntries() {
        do {
            // Encode entries array to data
            let data = try JSONEncoder().encode(entries)
            
            // Save data to UserDefaults
            if !entries.isEmpty {
                UserDefaults.standard.set(data, forKey: Constants.journalEntriesKey)
            }
        } catch {
            print("Error saving entries: \(error)")
        }
    }
    
    // Add a new entry
    func addEntry(quote: String) {
        let newEntry = JournalEntry(date: Date(), summary: quote, photoData: nil, relatedPhotosData: nil, tags: [], needToShowTags: false)
        entries.append(newEntry)
        saveEntries() // Save the updated entries to UserDefaults
    }
    
    // Edit an existing entry
    func editEntry(withSummary summary: String, newString: String) {
        let newEntry = JournalEntry(date: Date(), summary: newString, photoData: nil, relatedPhotosData: nil, tags: [], needToShowTags: false)
        if let index = entries.firstIndex(where: { $0.summary == summary }) {
            entries[index] = newEntry
            saveEntries()
        }
    }
    
    // Delete an entry
    func deleteEntry(where quote:String) {
        if let index = entries.firstIndex(where: { $0.summary == quote }) {
            entries.remove(at: index)
            saveEntries()
        }
    }
}
