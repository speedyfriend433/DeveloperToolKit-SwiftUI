//
//  SaveTemplateView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SaveTemplateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: APITesterViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var category = ""
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Template Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Category", text: $category)
                }
                
                Section {
                    Button("Save Template") {
                        saveTemplate()
                    }
                    .disabled(name.isEmpty || category.isEmpty)
                }
            }
            .navigationTitle("Save Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please fill in all required fields")
            }
        }
    }
    
    private func saveTemplate() {
        guard !name.isEmpty && !category.isEmpty else {
            showError = true
            return
        }
        
        viewModel.saveAsTemplate(
            name: name,
            description: description,
            category: category
        )
        dismiss()
    }
}
