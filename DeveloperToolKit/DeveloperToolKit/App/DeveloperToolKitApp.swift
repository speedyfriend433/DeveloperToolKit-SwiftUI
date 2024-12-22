//
//  DeveloperToolKitApp.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

@main
struct DeveloperToolkitApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .preferredColorScheme(.light) // This locks the app in light mode
        }
    }
}
