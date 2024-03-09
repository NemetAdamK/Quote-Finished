//
//  AddOrEditQuotedView.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import SwiftUI

struct AddOrEditQuotedView: View {
    @Binding var isPresented: Bool
    @State private var quoteText: String
    var journalEntry: JournalEntry?
    @EnvironmentObject var viewModel: JournalListViewModel

    init(isPresented: Binding<Bool>, journalEntry: JournalEntry? = nil) {
        self._isPresented = isPresented
        self.journalEntry = journalEntry
        self._quoteText = State(initialValue: journalEntry?.summary ?? "")
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    TextField("Enter quote", text: $quoteText,  axis: .vertical)
                        .lineLimit(5...10)
                        .padding()
                }
                Button("Save") {
                    if let entry = journalEntry {
                        viewModel.editEntry(withSummary: entry.summary, newString: quoteText)
                        isPresented = false
                    } else {
                        viewModel.addEntry(quote: quoteText)
                        isPresented = false
                    }
                    isPresented = false
                }
                .padding()
            }
            .navigationTitle(journalEntry != nil ? "Edit Quote" : "Add Quote")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
