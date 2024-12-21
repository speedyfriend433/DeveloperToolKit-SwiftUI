//
//  SnippetManagerView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SnippetManagerView: View {
    @StateObject private var viewModel = SnippetManagerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.snippets) { snippet in
                    NavigationLink(destination: SnippetDetailView(snippet: snippet)) {
                        SnippetRowView(snippet: snippet)
                    }
                }
                .onDelete { indexSet in
                    // Wrap the delete action in a Task to respect MainActor
                    Task {
                        await viewModel.deleteSnippet(at: indexSet)
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
        }
    }
}
