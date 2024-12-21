//
//  SnippetManagerViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

@MainActor
class SnippetManagerViewModel: ObservableObject {
    @Published var snippets: [CodeSnippet] = []
    @Published var showAddSnippet = false
    
    init() {
        loadSnippets()
    }
    
    func loadSnippets() {
        // In a real app, load from persistence
        snippets = []
    }
    
    func addSnippet(_ snippet: CodeSnippet) {
        snippets.append(snippet)
        // In a real app, save to persistence
    }
    
    func deleteSnippet(at offsets: IndexSet) async {
        snippets.remove(atOffsets: offsets)
        // In a real app, delete from persistence
    }
}
