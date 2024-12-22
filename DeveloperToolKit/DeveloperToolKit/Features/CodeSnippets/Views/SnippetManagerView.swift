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
            VStack(spacing: 0) {
                // Search and Filter Bar
                searchAndFilterBar
                
                if viewModel.snippets.isEmpty {
                    emptyStateView
                } else {
                    snippetsList
                }
            }
            .background(Theme.background)
            .navigationTitle("Code Snippets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showAddSnippet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.primary)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSnippet) {
                AddSnippetView(viewModel: viewModel)
            }
        }
    }
    
    private var searchAndFilterBar: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.text.opacity(0.5))
                TextField("Search snippets", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.text.opacity(0.5))
                    }
                }
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Filter Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.getAllTags(), id: \.self) { tag in
                        FilterChip(
                            title: tag,
                            isSelected: viewModel.selectedTags.contains(tag)
                        ) {
                            if viewModel.selectedTags.contains(tag) {
                                viewModel.selectedTags.remove(tag)
                            } else {
                                viewModel.selectedTags.insert(tag)
                            }
                            viewModel.filterSnippets()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
            .listRowBackground(Color.white)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.loadSnippets()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(Theme.primary.opacity(0.3))
            
            Text("No Snippets Found")
                .font(.title2)
                .foregroundColor(Theme.text)
            
            Text("Add your first code snippet by tapping the + button")
                .font(.subheadline)
                .foregroundColor(Theme.text.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.showAddSnippet = true
            } label: {
                Text("Add Snippet")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Theme.primary)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Theme.primary : Theme.background)
                .foregroundColor(isSelected ? .white : Theme.text)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Theme.primary : Theme.text.opacity(0.3), lineWidth: 1)
                )
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
