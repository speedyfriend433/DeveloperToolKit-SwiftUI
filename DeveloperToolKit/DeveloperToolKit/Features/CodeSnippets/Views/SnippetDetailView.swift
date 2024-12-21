//
//  SnippetDetailView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SnippetDetailView: View {
    let snippet: CodeSnippet
    @State private var isEditing = false
    @State private var editedCode = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Language and date info
                HStack {
                    LanguageBadge(language: snippet.language)
                    Spacer()
                    Text(formatDate(snippet.dateCreated))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(snippet.tags, id: \.self) { tag in
                            TagView(tag: tag)
                        }
                    }
                }
                
                // Code section
                VStack(alignment: .leading) {
                    Text("Code")
                        .font(.headline)
                    
                    if isEditing {
                        TextEditor(text: $editedCode)
                            .font(.system(.body, design: .monospaced))
                            .frame(minHeight: 200)
                            .border(Color.gray, width: 1)
                    } else {
                        CodeView(code: snippet.code, language: snippet.language)
                    }
                }
                
                // Action buttons
                HStack {
                    Button(action: copyToClipboard) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Button(action: toggleEdit) {
                        Label(isEditing ? "Done" : "Edit",
                              systemImage: isEditing ? "checkmark" : "pencil")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .navigationTitle(snippet.title)
        .onAppear {
            editedCode = snippet.code
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = snippet.code
    }
    
    private func toggleEdit() {
        isEditing.toggle()
    }
}

// Supporting Views
struct LanguageBadge: View {
    let language: String
    
    var body: some View {
        Text(language)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
    }
}

struct TagView: View {
    let tag: String
    
    var body: some View {
        Text(tag)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

struct CodeView: View {
    let code: String
    let language: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

#Preview {
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
}
