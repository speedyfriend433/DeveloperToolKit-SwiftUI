//
//  CoreDataManager.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import CoreData
import SwiftUI

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    
    private init() {
        // Register the transformer
        ValueTransformer.setValueTransformer(
            StringArrayTransformer(),
            forName: NSValueTransformerName("StringArrayTransformer")
        )
        
        container = NSPersistentContainer(name: "CodeSnippet")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
