//
//  Daily_InspoApp.swift
//  Daily Inspo
//
//  Created by Ádám-Krisztián Német on 08.03.2024.
//

import SwiftUI

@main
struct Daily_InspoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: JournalListViewModel())
        }
    }
}
