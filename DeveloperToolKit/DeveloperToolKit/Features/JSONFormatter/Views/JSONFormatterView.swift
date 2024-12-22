//
//  JSONFormatterView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct JSONFormatterView: View {
    @StateObject private var viewModel = JSONFormatterViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case input, output
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    inputSection
                    buttonSection
                    outputSection
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("JSON Formatter")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text(alertItem.dismissButton))
                )
            }
            .addKeyboardToolbar()
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Input JSON")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Button(action: { viewModel.clearInput() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.text.opacity(0.5))
                }
                .opacity(viewModel.inputJSON.isEmpty ? 0 : 1)
            }
            
            TextEditor(text: $viewModel.inputJSON)
                .frame(height: 200)
                .font(.system(.body, design: .monospaced))
                .focused($focusedField, equals: .input)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var buttonSection: some View {
        HStack(spacing: 16) {
            ActionButton(
                title: "Format",
                icon: "arrow.right.circle.fill",
                action: viewModel.formatJSON
            )
            
            ActionButton(
                title: "Minify",
                icon: "arrow.left.circle.fill",
                action: viewModel.minifyJSON
            )
            
            ActionButton(
                title: "Copy",
                icon: "doc.on.doc.fill",
                action: viewModel.copyToClipboard
            )
        }
    }
    
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Formatted Output")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                if !viewModel.formattedJSON.isEmpty {
                    Text("\(viewModel.formattedJSON.count) characters")
                        .font(.caption)
                        .foregroundColor(Theme.text.opacity(0.5))
                }
            }
            
            if viewModel.formattedJSON.isEmpty {
                emptyStateView
            } else {
                outputTextView
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down.circle")
                .font(.system(size: 40))
                .foregroundColor(Theme.primary.opacity(0.3))
            
            Text("Formatted JSON will appear here")
                .font(.subheadline)
                .foregroundColor(Theme.text.opacity(0.5))
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
    
    private var outputTextView: some View {
        ScrollView {
            Text(viewModel.formattedJSON)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
        }
        .frame(height: 200)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(.callout, design: .rounded, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 2)
            )
        }
    }
}
