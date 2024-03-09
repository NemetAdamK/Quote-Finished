//
//  GratitudeDetailView.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import SwiftUI

struct GratitudeDetailView: View {
    let entry: JournalEntry
    @EnvironmentObject var viewModel: JournalListViewModel
    @State private var showDeleteConfirmation = false
    @State private var showAddQuoteSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.date.formattedMonthDayYear())
                .font(.footnote)
                .foregroundStyle(.gray)
            Spacer()
                .frame(height: 10)
            Text(entry.summary)
                .font(.body)
                .fontWeight(.semibold)
                /* Normal underline */
                .underline(true,color:.blue)
                // Design similar custom underline , but that would need fixing since it behaves odd at more than 1 line.
//                .overlay(
//                    Rectangle().foregroundStyle(Color.blue).frame(height: 3).offset(y: -2)
//                    , alignment: .bottom)

            Spacer()
                .frame(height: 20)
            if let photo = entry.photo {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 10)
            } else {
                Image("placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            Spacer()
                .frame(height: 10)
            if let relatedPhotos = entry.relatedPhotos {
                HStack {
                    ForEach(relatedPhotos, id: \.self) { photo in
                        Image(uiImage: photo)
                            .resizable()
                            .frame(width: 70,height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                Spacer()
                    .frame(height: 20)
            } else {
                // Add extra space if no related images exist
                Spacer()
                    .frame(height: 10)
            }

            if !entry.tags.isEmpty {
                HStack {
                    ForEach(entry.tags, id: \.self) { tag in
                        TagView(tag: tag)
                    }
                }
            }
            Spacer()
            
        }
        .padding()
        .actionSheet(isPresented: $showDeleteConfirmation) {
            ActionSheet(
                title: Text("Delete Entry"),
                message: Text("Are you sure you want to delete this entry?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        viewModel.deleteEntry(where: entry.summary)
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showAddQuoteSheet) {
            AddOrEditQuotedView(isPresented: $showAddQuoteSheet,journalEntry: entry)
                .environmentObject(viewModel)
        }

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button(action: {
                        showAddQuoteSheet = true
                    }) {
                        Image(systemName: "pencil")
                            .tint(.black)
                    }
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .tint(.black)
                    }
                }
            }
        }
        
    }
}

