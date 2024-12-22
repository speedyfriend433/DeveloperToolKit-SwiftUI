//
//  SnippetDetailView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SnippetDetailView: View {
    let snippet: SnippetModel
    @ObservedObject var viewModel: SnippetManagerViewModel
    @State private var isEditing = false
    @State private var editedCode = ""
    @State private var editedTitle = ""
    @State private var editedLanguage = ""
    @State private var editedTags = ""
    @FocusState private var focusedField: DetailField?
    
    enum DetailField {
        case title, code, language, tags
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isEditing {
                    editView
                } else {
                    displayView
                }
            }
            .padding()
        }
        .background(Theme.background)
        .navigationTitle(isEditing ? "Edit Snippet" : snippet.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        saveChanges()
                    }
                    isEditing.toggle()
                }
            }
        }
        .onAppear {
            editedCode = snippet.code
            editedTitle = snippet.title
            editedLanguage = snippet.language
            editedTags = snippet.tags.joined(separator: ", ")
        }
        .addKeyboardToolbar()
    }
    
    private var displayView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Metadata Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(snippet.language)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primary.opacity(0.1))
                        .foregroundColor(Theme.primary)
                        .cornerRadius(10)
                    
                    Spacer()
                    
                    Text(snippet.dateCreated.formatted())
                        .font(.caption)
                        .foregroundColor(Theme.text.opacity(0.5))
                }
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(snippet.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.secondary.opacity(0.1))
                                .foregroundColor(Theme.secondary)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Code Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Code")
                        .font(.headline)
                        .foregroundColor(Theme.text)
                    
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.string = snippet.code
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(.caption)
                            .foregroundColor(Theme.primary)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: true) {
                    Text(snippet.code)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Actions
            VStack(spacing: 12) {
                ShareButton(code: snippet.code)
                DeleteButton {
                    // Handle delete
                }
            }
        }
    }
    
    private var editView: some View {
            VStack(spacing: 20) {
                // Title Input
                DetailInputField(
                    title: "Title",
                    text: $editedTitle,
                    icon: "text.alignleft",
                    focused: $focusedField,
                    field: .title
                )
                
                // Language Input
                DetailInputField(
                    title: "Language",
                    text: $editedLanguage,
                    icon: "chevron.left.forwardslash.chevron.right",
                    focused: $focusedField,
                    field: .language
                )
                
                // Tags Input
                DetailInputField(
                    title: "Tags (comma separated)",
                    text: $editedTags,
                    icon: "tag",
                    focused: $focusedField,
                    field: .tags
                )
                
                // Code Input
                VStack(alignment: .leading, spacing: 8) {
                    Label("Code", systemImage: "doc.text")
                        .font(.headline)
                        .foregroundColor(Theme.text)
                    
                    TextEditor(text: $editedCode)
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
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    
    private func saveChanges() {
        let updatedSnippet = SnippetModel(
            id: snippet.id,
            title: editedTitle,
            code: editedCode,
            language: editedLanguage,
            tags: editedTags.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            dateCreated: snippet.dateCreated
        )
        
        Task {
            await viewModel.updateSnippet(updatedSnippet)
        }
        isEditing = false
    }
}

struct DetailInputField: View {
    let title: String
    let text: Binding<String>
    let icon: String
    let focused: FocusState<SnippetDetailView.DetailField?>.Binding
    let field: SnippetDetailView.DetailField
    
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

// Supporting Views
struct ShareButton: View {
    let code: String
    
    var body: some View {
        ShareLink(
            item: code,
            preview: SharePreview("Code Snippet", image: "doc.text")
        ) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share Snippet")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.primary)
            .cornerRadius(12)
        }
    }
}

struct DeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "trash")
                Text("Delete Snippet")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.error)
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationView {
        SnippetDetailView(
            snippet: SnippetModel(
                id: UUID(),
                title: "Example Snippet",
                code: "print(\"Hello, World!\")",
                language: "Swift",
                tags: ["iOS", "Swift"],
                dateCreated: Date()
            ),
            viewModel: SnippetManagerViewModel()
        )
    }
}
