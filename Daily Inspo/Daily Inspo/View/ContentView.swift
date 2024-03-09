//
//  ContentView.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: JournalListViewModel
    @State private var isLoading = true
    @State private var selectedTab = 0
    @State private var showSettingsSheet = false
    @State private var showAddQuoteSheet = false

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Hello. I tested out also the tab view")
                .tabItem {
                    Image(systemName: "star")
                    Text("About me")
                }
                .tag(1)
            
            NavigationView {
                if isLoading {
                    ProgressView("Loading...")
                        .onAppear {
                            viewModel.fetchEntries {
                                isLoading = false
                            }
                        }
                } else {
                    List(viewModel.entries.sorted(by: { $0.date > $1.date })) { entry in
                        CustomListElement(date: entry.date, summary: entry.summary, photo: entry.photo, tags: entry.tags, needToShowTags: entry.needToShowTags)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .background(
                                NavigationLink(destination: GratitudeDetailView(entry: entry)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                .buttonStyle(PlainButtonStyle())
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(GroupedListStyle())
                    .listRowSpacing(-5)
                    .toolbarBackground(.visible, for: .navigationBar) // added to prevent transparency shifting

                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("Daily Gratitude")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack {
                                Button(action: {
                                    showSettingsSheet.toggle()
                                }) {
                                    Image(systemName: "gear")
                                        .tint(.black)
                                }
                                Button(action: {
                                    showAddQuoteSheet.toggle()
                                }) {
                                    Image(systemName: "plus")
                                        .tint(.black)
                                }
                            }
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Entries")
            }
            .tag(0)
        }
        .tint(.black) // Added to make back button black
        .preferredColorScheme(.light)
        .sheet(isPresented: $showSettingsSheet) {
            // Content of the modal sheet
            Text("Settings")
        }
        .sheet(isPresented: $showAddQuoteSheet) {
            AddOrEditQuotedView(isPresented: $showAddQuoteSheet)
                .environmentObject(viewModel)
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView(viewModel: JournalListViewModel())
}
