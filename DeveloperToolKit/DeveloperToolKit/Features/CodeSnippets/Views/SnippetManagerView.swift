//
//  SnippetManagerView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SnippetManagerView: View {
    @StateObject private var viewModel = SnippetManagerViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                searchBar
                
                // Filters
                filterSection
                
                // Snippets list
                List {
                    ForEach(viewModel.snippets, id: \.id) { snippet in
                        NavigationLink(destination: SnippetDetailView(snippet: snippet, viewModel: viewModel)) {
                            SnippetRowView(snippet: snippet)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            await viewModel.deleteSnippet(at: indexSet)
                        }
                    }
                }
            }
            .navigationTitle("Code Snippets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showAddSnippet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSnippet) {
                AddSnippetView(viewModel: viewModel)
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text(alertItem.dismissButton))
                )
            }
        }
    }
    
    private var searchBar: some View {
        TextField("Search snippets", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterSnippets()
            }
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                // Language filter
                Menu {
                    ForEach(viewModel.getAllLanguages(), id: \.self) { language in
                        Button(language) {
                            viewModel.selectedLanguageFilter = language
                            viewModel.filterSnippets()
                        }
                    }
                    
                    Button("Clear") {
                        viewModel.selectedLanguageFilter = nil
                        viewModel.filterSnippets()
                    }
                } label: {
                    Label(
                        viewModel.selectedLanguageFilter ?? "Language",
                        systemImage: "chevron.down"
                    )
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                
                // Tags
                ForEach(viewModel.getAllTags(), id: \.self) { tag in
                    TagFilterButton(
                        tag: tag,
                        isSelected: viewModel.selectedTags.contains(tag),
                        action: {
                            if viewModel.selectedTags.contains(tag) {
                                viewModel.selectedTags.remove(tag)
                            } else {
                                viewModel.selectedTags.insert(tag)
                            }
                            viewModel.filterSnippets()
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var snippetsList: some View {
        List {
            ForEach(viewModel.snippets) { snippet in
                NavigationLink(destination: SnippetDetailView(snippet: snippet, viewModel: viewModel)) {
                    SnippetRowView(snippet: snippet)
                }
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.deleteSnippet(at: indexSet)
                }
            }
        }
    }
}

struct TagFilterButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}
