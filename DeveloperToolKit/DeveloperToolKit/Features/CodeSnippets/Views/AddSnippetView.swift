//
//  AddSnippetView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct AddSnippetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SnippetManagerViewModel
    
    @State private var title = ""
    @State private var code = ""
    @State private var language = ""
    @State private var tags = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Language", text: $language)
                TextField("Tags (comma separated)", text: $tags)
                TextEditor(text: $code)
                    .frame(height: 200)
            }
            .navigationTitle("Add Snippet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSnippet()
                    }
                }
            }
        }
    }
    
    private func saveSnippet() {
        let snippet = CodeSnippet(
            id: UUID(),
            title: title,
            code: code,
            language: language,
            tags: tags.split(separator: ",").map(String.init),
            dateCreated: Date()
        )
        
        viewModel.addSnippet(snippet)
        dismiss()
    }
}
