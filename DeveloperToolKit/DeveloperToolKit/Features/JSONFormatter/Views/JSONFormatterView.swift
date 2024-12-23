//
//  JSONFormatterView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct JSONFormatterView: View {
    @StateObject private var viewModel = JSONFormatterViewModel()
    @FocusState private var focusedField: FormatterField?
    @State private var showOptions = false
    @State private var showSamples = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    inputSection
                    toolbarSection
                    outputSection
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("JSON Formatter")
            .toolbar {
                // Navigation Bar Items
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showOptions = true
                        } label: {
                            Label("Formatting Options", systemImage: "gear")
                        }
                        
                        Button {
                            showSamples = true
                        } label: {
                            Label("Sample JSON", systemImage: "doc.text")
                        }
                        
                        Button {
                            viewModel.pasteFromClipboard()
                        } label: {
                            Label("Paste", systemImage: "doc.on.clipboard")
                        }
                        
                        Button {
                            viewModel.clearAll()
                        } label: {
                            Label("Clear All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                // Keyboard Toolbar
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .sheet(isPresented: $showOptions) {
                FormatterOptionsView(options: $viewModel.options)
            }
            .sheet(isPresented: $showSamples) {
                JSONSamplesView(viewModel: viewModel)
            }
        }
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Input JSON")
                    .font(.headline)
                
                Spacer()
                
                if !viewModel.inputJSON.isEmpty {
                    Button(action: { viewModel.inputJSON = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            TextEditor(text: $viewModel.inputJSON)
                .frame(height: 200)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2))
                )
                .focused($focusedField, equals: .input)
        }
    }
    
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Formatted Output")
                    .font(.headline)
                
                Spacer()
                
                if !viewModel.formattedJSON.isEmpty {
                    Text("\(viewModel.formattedJSON.count) characters")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            if viewModel.formattedJSON.isEmpty {
                emptyStateView
            } else {
                TextEditor(text: .constant(viewModel.formattedJSON))
                    .frame(height: 200)
                    .font(.system(.body, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2))
                    )
                    .focused($focusedField, equals: .output)
            }
        }
    }
    
    private var toolbarSection: some View {
        HStack(spacing: 16) {
            FormatterButton(
                title: "Format",
                icon: "arrow.right.circle.fill"
            ) {
                viewModel.formatJSON()
            }
            
            FormatterButton(
                title: "Minify",
                icon: "arrow.left.circle.fill"
            ) {
                viewModel.minifyJSON()
            }
            
            FormatterButton(
                title: "Copy",
                icon: "doc.on.doc.fill"
            ) {
                viewModel.copyToClipboard()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Formatted JSON will appear here")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2))
        )
    }
}

struct FormatterButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(.callout, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.primary)
            .cornerRadius(8)
        }
    }
}

// Supporting Views
    
    /*private var lineNumbers: some View {
        let lines = json.components(separatedBy: .newlines)
        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<lines.count, id: \.self) { index in
                Text("\(index + 1)")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
    }
    
    private var highlightedText: some View {
        Text(AttributedString(highlighting: json))
            .padding(8)
            .textSelection(.enabled)
    }

struct JSONSamplesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JSONFormatterViewModel
    
    var body: some View {
        NavigationView {
            List(JSONSample.allCases) { sample in
                VStack(alignment: .leading, spacing: 8) {
                    Text(sample.name)
                        .font(.headline)
                    
                    Text(sample.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.inputJSON = sample.json
                    dismiss()
                }
            }
            .navigationTitle("Sample JSON")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}*/

// MARK: - String Extension for Syntax Highlighting
extension AttributedString {
    init(highlighting json: String) {
        let attributedString = NSMutableAttributedString(string: json)
        
        // Define patterns and colors for different JSON elements
        let patterns: [(pattern: String, color: Color)] = [
            ("\".*?\"", .blue), // Strings
            ("\\b\\d+\\.?\\d*\\b", .orange), // Numbers
            ("\\b(true|false|null)\\b", .purple), // Keywords
            ("[{\\[\\]},:]", .gray) // Symbols
        ]
        
        // Apply highlighting
        for (pattern, color) in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern) else { continue }
            let range = NSRange(json.startIndex..., in: json)
            let matches = regex.matches(in: json, range: range)
            
            for match in matches {
                attributedString.addAttribute(.foregroundColor,
                                           value: UIColor(color),
                                           range: match.range)
            }
        }
        
        self.init(attributedString)
    }
}

#Preview {
    JSONFormatterView()
}
