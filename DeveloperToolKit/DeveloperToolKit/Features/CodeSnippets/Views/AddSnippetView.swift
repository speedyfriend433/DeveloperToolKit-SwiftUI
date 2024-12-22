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
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, code, language, tags
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title Input
                    InputField(
                        title: "Title",
                        text: $title,
                        icon: "text.alignleft",
                        focused: $focusedField,
                        field: .title
                    )
                    
                    // Language Input
                    InputField(
                        title: "Language",
                        text: $language,
                        icon: "chevron.left.forwardslash.chevron.right",
                        focused: $focusedField,
                        field: .language
                    )
                    
                    // Tags Input
                    InputField(
                        title: "Tags (comma separated)",
                        text: $tags,
                        icon: "tag",
                        focused: $focusedField,
                        field: .tags
                    )
                    
                    // Code Input
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Code", systemImage: "doc.text")
                            .font(.headline)
                            .foregroundColor(Theme.text)
                        
                        TextEditor(text: $code)
                            .font(.system(.body, design: .monospaced))
                            .frame(height: 200)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.border, lineWidth: 1)
                            )
                            .focused($focusedField, equals: .code)
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Add Snippet")
            .navigationBarTitleDisplayMode(.inline)
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

struct InputField: View {
    let title: String
    let text: Binding<String>
    let icon: String
    let focused: FocusState<AddSnippetView.Field?>.Binding
    let field: AddSnippetView.Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(Theme.text)
            
            TextField(title, text: text)
                .textFieldStyle(ModernTextFieldStyle())
                .focused(focused, equals: field)
        }
    }
}
