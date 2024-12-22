//
//  SnippetManagerViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI
import CoreData

@MainActor
class SnippetManagerViewModel: ObservableObject {
    @Published var snippets: [SnippetModel] = []
    @Published var showAddSnippet = false
    @Published var searchText = ""
    @Published var selectedLanguageFilter: String?
    @Published var selectedTags: Set<String> = []
    @Published var alertItem: AlertItem?
    
    private let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataManager.shared.viewContext
        loadSnippets()
    }
    
    func loadSnippets() {
        let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
        
        // Apply filters
        var predicates: [NSPredicate] = []
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@ OR code CONTAINS[cd] %@",
                                        searchText, searchText))
        }
        
        if let language = selectedLanguageFilter {
            predicates.append(NSPredicate(format: "language == %@", language))
        }
        
        if !selectedTags.isEmpty {
            let tagPredicates = selectedTags.map { tag in
                NSPredicate(format: "ANY tags == %@", tag)
            }
            predicates.append(NSCompoundPredicate(andPredicateWithSubpredicates: tagPredicates))
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CodeSnippetEntity.dateCreated,
                                                  ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            snippets = entities.map { entity in
                SnippetModel(
                    id: entity.id ?? UUID(),
                    title: entity.title ?? "",
                    code: entity.code ?? "",
                    language: entity.language ?? "",
                    tags: (entity.tags as? [String]) ?? [],
                    dateCreated: entity.dateCreated ?? Date()
                )
            }
        } catch {
            print("Error loading snippets: \(error)")
            alertItem = AlertItem(
                title: "Error",
                message: "Failed to load snippets: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func addSnippet(_ snippet: SnippetModel) async {
        let entity = CodeSnippetEntity(context: context)
        entity.id = snippet.id
        entity.title = snippet.title
        entity.code = snippet.code
        entity.language = snippet.language
        entity.tags = snippet.tags as NSObject
        entity.dateCreated = snippet.dateCreated
        
        do {
            try context.save()
            loadSnippets()
            alertItem = AlertItem(
                title: "Success",
                message: "Snippet added successfully",
                dismissButton: "OK"
            )
        } catch {
            print("Error adding snippet: \(error)")
            alertItem = AlertItem(
                title: "Error",
                message: "Failed to save snippet: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func updateSnippet(_ snippet: SnippetModel) async {
        let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
        request.predicate = NSPredicate(format: "id == %@", snippet.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                entity.title = snippet.title
                entity.code = snippet.code
                entity.language = snippet.language
                entity.tags = snippet.tags as NSObject
                
                try context.save()
                loadSnippets()
                
                alertItem = AlertItem(
                    title: "Success",
                    message: "Snippet updated successfully",
                    dismissButton: "OK"
                )
            }
        } catch {
            print("Error updating snippet: \(error)")
            alertItem = AlertItem(
                title: "Error",
                message: "Failed to update snippet: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func deleteSnippet(at offsets: IndexSet) async {
        for index in offsets {
            guard index < snippets.count else { continue }
            let snippet = snippets[index]
            let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
            request.predicate = NSPredicate(format: "id == %@", snippet.id as CVarArg)
            
            do {
                let entities = try context.fetch(request)
                if let entity = entities.first {
                    context.delete(entity)
                }
            } catch {
                print("Error deleting snippet: \(error)")
                alertItem = AlertItem(
                    title: "Error",
                    message: "Failed to delete snippet: \(error.localizedDescription)",
                    dismissButton: "OK"
                )
                return
            }
        }
        
        do {
            try context.save()
            loadSnippets()
            alertItem = AlertItem(
                title: "Success",
                message: "Snippet deleted successfully",
                dismissButton: "OK"
            )
        } catch {
            print("Error saving after delete: \(error)")
            alertItem = AlertItem(
                title: "Error",
                message: "Failed to save changes: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func getAllLanguages() -> [String] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CodeSnippetEntity")
        request.propertiesToFetch = ["language"]
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(request) as? [[String: String]] ?? []
            return results.compactMap { $0["language"] }.sorted()
        } catch {
            print("Error fetching languages: \(error)")
            return []
        }
    }
    
    func getAllTags() -> [String] {
        let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
        
        do {
            let entities = try context.fetch(request)
            let allTags = entities.compactMap { $0.tags as? [String] }.flatMap { $0 }
            return Array(Set(allTags)).sorted()
        } catch {
            print("Error fetching tags: \(error)")
            return []
        }
    }
    
    func filterSnippets() {
        loadSnippets()
    }
    
    func clearFilters() {
        searchText = ""
        selectedLanguageFilter = nil
        selectedTags.removeAll()
        loadSnippets()
    }
}
