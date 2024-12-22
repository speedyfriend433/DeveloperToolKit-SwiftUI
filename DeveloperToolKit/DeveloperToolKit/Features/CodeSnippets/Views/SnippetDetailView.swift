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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if isEditing {
                    editingView
                } else {
                    displayView
                }
            }
            .padding()
        }
        .navigationTitle(snippet.title)
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
    }
    
    private var displayView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Language and date
            HStack {
                Text(snippet.language)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(snippet.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(snippet.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Code
            Text("Code")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: true) {
                Text(snippet.code)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            // Copy button
            Button(action: {
                UIPasteboard.general.string = snippet.code
            }) {
                Label("Copy Code", systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var editingView: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $editedTitle)
                .textFieldStyle(.roundedBorder)
            
            TextField("Language", text: $editedLanguage)
                .textFieldStyle(.roundedBorder)
            
            TextField("Tags (comma separated)", text: $editedTags)
                .textFieldStyle(.roundedBorder)
            
            Text("Code")
                .font(.headline)
            
            TextEditor(text: $editedCode)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
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

/*#Preview {
    NavigationView {
        SnippetDetailView(snippet: CodeSnippet(
            id: UUID(),
            title: "Example Snippet",
            code: """
            func example() {
                print("Hello, World!")
            }
            """,
            language: "Swift",
            tags: ["iOS", "Swift", "Example"],
            dateCreated: Date()
        ))
    }
}*/
