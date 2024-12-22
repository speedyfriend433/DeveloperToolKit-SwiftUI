//
//  AddSnippetView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct AddSnippetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SnippetManagerViewModel
    
    @State private var title = ""
    @State private var code = ""
    @State private var language = ""
    @State private var tags = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, code, language, tags
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                        .focused($focusedField, equals: .title)
                    
                    TextField("Language", text: $language)
                        .focused($focusedField, equals: .language)
                    
                    TextField("Tags (comma separated)", text: $tags)
                        .focused($focusedField, equals: .tags)
                }
                
                Section(header: Text("Code")) {
                    TextEditor(text: $code)
                        .focused($focusedField, equals: .code)
                        .frame(minHeight: 200)
                }
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
                    .disabled(title.isEmpty || code.isEmpty)
                }
            }
            .addKeyboardToolbar()
        }
    }
    
    private func saveSnippet() {
        let snippet = SnippetModel(
            id: UUID(),
            title: title,
            code: code,
            language: language,
            tags: tags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            dateCreated: Date()
        )
        
        Task {
            await viewModel.addSnippet(snippet)
        }
        dismiss()
    }
}
