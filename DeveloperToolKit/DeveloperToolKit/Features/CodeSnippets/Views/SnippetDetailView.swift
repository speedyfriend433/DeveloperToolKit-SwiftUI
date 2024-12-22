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
    @FocusState private var focusedField: FormFieldType?
    @Environment(\.dismiss) private var dismiss
    @State private var currentSnippet: SnippetModel
    
    init(snippet: SnippetModel, viewModel: SnippetManagerViewModel) {
        self.snippet = snippet
        self.viewModel = viewModel
        _currentSnippet = State(initialValue: snippet)
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
        .navigationTitle(isEditing ? "Edit Snippet" : currentSnippet.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        Task {
                            await saveChanges()
                        }
                    } else {
                        isEditing.toggle()
                    }
                }
                .disabled(isEditing && editedTitle.isEmpty)
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .onChange(of: viewModel.snippets) { newSnippets in
            if let updatedSnippet = newSnippets.first(where: { $0.id == currentSnippet.id }) {
                currentSnippet = updatedSnippet
                if !isEditing {
                    setupInitialValues()
                }
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: .default(Text(alertItem.dismissButton)) {
                    if alertItem.title == "Success" {
                        isEditing = false
                    }
                }
            )
        }
    }
}

// MARK: - Subviews
extension SnippetDetailView {
    var displayView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Metadata Card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(currentSnippet.language)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primary.opacity(0.1))
                        .foregroundColor(Theme.primary)
                        .cornerRadius(10)
                    
                    Spacer()
                    
                    Text(currentSnippet.dateCreated.formatted())
                        .font(.caption)
                        .foregroundColor(Theme.text.opacity(0.5))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(currentSnippet.tags, id: \.self) { tag in
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
                        UIPasteboard.general.string = currentSnippet.code
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                            .font(.caption)
                            .foregroundColor(Theme.primary)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: true) {
                    Text(currentSnippet.code)
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
                ShareButton(code: currentSnippet.code)
                DeleteButton {
                    Task {
                        await viewModel.deleteSnippet(at: IndexSet([0]))
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Supporting Views
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
    
    var editView: some View {
        VStack(spacing: 20) {
            DetailInputField(
                title: "Title",
                text: $editedTitle,
                icon: "text.alignleft",
                focused: $focusedField,
                field: .title
            )
            
            DetailInputField(
                title: "Language",
                text: $editedLanguage,
                icon: "chevron.left.forwardslash.chevron.right",
                focused: $focusedField,
                field: .language
            )
            
            DetailInputField(
                title: "Tags (comma separated)",
                text: $editedTags,
                icon: "tag",
                focused: $focusedField,
                field: .tags
            )
            
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
}

// MARK: - Helper Methods
extension SnippetDetailView {
    func setupInitialValues() {
        editedCode = currentSnippet.code
        editedTitle = currentSnippet.title
        editedLanguage = currentSnippet.language
        editedTags = currentSnippet.tags.joined(separator: ", ")
    }
    
    func saveChanges() async {
        guard !editedTitle.isEmpty else { return }
        
        let updatedSnippet = SnippetModel(
            id: currentSnippet.id,
            title: editedTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            code: editedCode.trimmingCharacters(in: .whitespacesAndNewlines),
            language: editedLanguage.trimmingCharacters(in: .whitespacesAndNewlines),
            tags: editedTags.split(separator: ",")
                .map { String($0.trimmingCharacters(in: .whitespaces)) }
                .filter { !$0.isEmpty },
            dateCreated: currentSnippet.dateCreated
        )
        
        await viewModel.updateSnippet(updatedSnippet)
        
        if viewModel.alertItem?.title == "Success" {
            currentSnippet = updatedSnippet
        }
    }
}

#if DEBUG
struct SnippetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SnippetDetailView(
                snippet: SnippetModel(
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
                ),
                viewModel: SnippetManagerViewModel()
            )
        }
    }
}
#endif
