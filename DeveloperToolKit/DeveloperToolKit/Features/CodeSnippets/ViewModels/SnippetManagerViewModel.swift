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
    
    private let context = CoreDataManager.shared.viewContext
    
    init() {
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
            alertItem = AlertItem(
                title: "Error",
                message: "Failed to load snippets: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func addSnippet(_ snippet: SnippetModel) {
            let entity = CodeSnippetEntity(context: context)
            updateEntity(entity, with: snippet)
            CoreDataManager.shared.save()
            loadSnippets()
        }
        
        func updateSnippet(_ snippet: SnippetModel) {
            let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
            request.predicate = NSPredicate(format: "id == %@", snippet.id as CVarArg)
            
            do {
                let entities = try context.fetch(request)
                if let entity = entities.first {
                    updateEntity(entity, with: snippet)
                    CoreDataManager.shared.save()
                    loadSnippets()
                }
            } catch {
                alertItem = AlertItem(
                    title: "Error",
                    message: "Failed to update snippet: \(error.localizedDescription)",
                    dismissButton: "OK"
                )
            }
        }
    
    private func updateEntity(_ entity: CodeSnippetEntity, with snippet: SnippetModel) {
            entity.id = snippet.id
            entity.title = snippet.title
            entity.code = snippet.code
            entity.language = snippet.language
            entity.tags = snippet.tags as NSArray
            entity.dateCreated = snippet.dateCreated
        }
        
        func getAllTags() -> [String] {
            let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
            
            do {
                let entities = try context.fetch(request)
                let allTags = entities.compactMap { $0.tags as? [String] }.flatMap { $0 }
                return Array(Set(allTags)).sorted()
            } catch {
                return []
            }
        }
    
    func deleteSnippet(at offsets: IndexSet) {
        let snippetsToDelete = offsets.map { snippets[$0] }
        
        for snippet in snippetsToDelete {
            let request = NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
            request.predicate = NSPredicate(format: "id == %@", snippet.id as CVarArg)
            
            do {
                let entities = try context.fetch(request)
                if let entity = entities.first {
                    context.delete(entity)
                }
            } catch {
                alertItem = AlertItem(
                    title: "Error",
                    message: "Failed to delete snippet: \(error.localizedDescription)",
                    dismissButton: "OK"
                )
            }
        }
        
        CoreDataManager.shared.save()
        loadSnippets()
    }
    
    // MARK: - Helper Methods
    
    func getAllLanguages() -> [String] {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CodeSnippetEntity")
            request.propertiesToFetch = ["language"]
            request.returnsDistinctResults = true
            request.resultType = .dictionaryResultType
            
            do {
                let results = try context.fetch(request) as? [[String: String]] ?? []
                return results.compactMap { $0["language"] }.sorted()
            } catch {
                return []
            }
        }
    
    func filterSnippets() {
        loadSnippets() // This will apply the current filters
    }
    
    func clearFilters() {
        searchText = ""
        selectedLanguageFilter = nil
        selectedTags.removeAll()
        loadSnippets()
    }
}
