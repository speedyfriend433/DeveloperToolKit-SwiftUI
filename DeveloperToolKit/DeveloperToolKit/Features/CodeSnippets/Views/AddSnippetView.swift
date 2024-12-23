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
    @FocusState private var focusedField: FormFieldType?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    AddSnippetInputField(
                        title: "Title",
                        text: $title,
                        icon: "text.alignleft",
                        focused: $focusedField,
                        field: .title
                    )
                    
                    AddSnippetInputField(
                        title: "Language",
                        text: $language,
                        icon: "chevron.left.forwardslash.chevron.right",
                        focused: $focusedField,
                        field: .language
                    )
                    
                    AddSnippetInputField(  // And here
                        title: "Tags (comma separated)",
                        text: $tags,
                        icon: "tag",
                        focused: $focusedField,
                        field: .tags
                    )
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

struct AddSnippetInputField: View {
    let title: String
    let text: Binding<String>
    let icon: String
    let focused: FocusState<FormFieldType?>.Binding
    let field: FormFieldType
    
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

#if DEBUG
struct AddSnippetView_Previews: PreviewProvider {
    static var previews: some View {
        AddSnippetView(viewModel: SnippetManagerViewModel())
    }
}
#endif
