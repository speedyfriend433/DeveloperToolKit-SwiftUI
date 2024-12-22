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
    @State private var showOptions = false
    @State private var showSamples = false
    
    enum Field {
        case input, output
    }
    
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showOptions = true }) {
                            Label("Formatting Options", systemImage: "gear")
                        }
                        
                        Button(action: { showSamples = true }) {
                            Label("Sample JSON", systemImage: "doc.text")
                        }
                        
                        Button(action: viewModel.clearAll) {
                            Label("Clear All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showOptions) {
                FormattingOptionsView(options: $viewModel.options)
            }
            .sheet(isPresented: $showSamples) {
                JSONSamplesView(viewModel: viewModel)
            }
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
    
    private var toolbarSection: some View {
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
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Input JSON")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                if !viewModel.inputJSON.isEmpty {
                    Button(action: viewModel.clearInput) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.text.opacity(0.5))
                    }
                }
            }
            
            JSONInputEditor(
                text: $viewModel.inputJSON,
                isError: viewModel.hasError,
                focused: $focusedField,
                field: .input
            )
            
            if viewModel.hasError {
                Text(viewModel.errorMessage)
                    .font(.caption)
                    .foregroundColor(Theme.error)
            }
            
            HStack {
                Text("\(viewModel.inputJSON.count) characters")
                    .font(.caption)
                    .foregroundColor(Theme.text.opacity(0.5))
                
                Spacer()
                
                Button("Paste") {
                    viewModel.pasteFromClipboard()
                }
                .font(.caption)
                .foregroundColor(Theme.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
                JSONSyntaxHighlightedView(json: viewModel.formattedJSON)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
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
}

// Supporting Views
struct JSONInputEditor: View {
    @Binding var text: String
    let isError: Bool
    let focused: FocusState<JSONFormatterView.Field?>.Binding
    let field: JSONFormatterView.Field
    
    var body: some View {
        TextEditor(text: $text)
            .frame(height: 200)
            .font(.system(.body, design: .monospaced))
            .focused(focused, equals: field)
            .scrollContentBackground(.hidden)
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isError ? Theme.error : Theme.border, lineWidth: 1)
            )
    }
}

struct JSONSyntaxHighlightedView: View {
    let json: String
    @State private var showLineNumbers = true
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(alignment: .top, spacing: 0) {
                if showLineNumbers {
                    lineNumbers
                }
                
                highlightedText
            }
        }
        .frame(height: 200)
        .font(.system(.body, design: .monospaced))
    }
    
    private var lineNumbers: some View {
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
}

struct FormattingOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var options: JSONFormatterOptions
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Formatting")) {
                    Stepper("Indentation: \(options.indentationSpaces) spaces",
                           value: $options.indentationSpaces, in: 1...8)
                    
                    Toggle("Sort Keys", isOn: $options.sortKeys)
                    Toggle("Escape Slashes", isOn: $options.escapeSlashes)
                    Toggle("Escape Unicode", isOn: $options.escapeUnicode)
                }
            }
            .navigationTitle("Formatting Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
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
}

// MARK: - Sample JSON
enum JSONSample: CaseIterable, Identifiable {
    case simple
    case nested
    case array
    case complex
    
    var id: String { name }
    
    var name: String {
        switch self {
        case .simple: return "Simple Object"
        case .nested: return "Nested Object"
        case .array: return "Array"
        case .complex: return "Complex Object"
        }
    }
    
    var description: String {
        switch self {
        case .simple: return "Basic key-value pairs"
        case .nested: return "Object with nested objects"
        case .array: return "Array of objects"
        case .complex: return "Complex nested structure"
        }
    }
    
    var json: String {
        switch self {
        case .simple:
            return """
            {
                "name": "John Doe",
                "age": 30,
                "city": "New York"
            }
            """
        case .nested:
            return """
            {
                "person": {
                    "name": "John Doe",
                    "address": {
                        "street": "123 Main St",
                        "city": "New York",
                        "country": "USA"
                    }
                }
            }
            """
        case .array:
            return """
            {
                "people": [
                    {
                        "name": "John",
                        "age": 30
                    },
                    {
                        "name": "Jane",
                        "age": 25
                    }
                ]
            }
            """
        case .complex:
            return """
            {
                "company": {
                    "name": "Tech Corp",
                    "employees": [
                        {
                            "id": 1,
                            "name": "John Doe",
                            "position": "Developer",
                            "skills": ["Swift", "iOS", "SwiftUI"],
                            "contact": {
                                "email": "john@example.com",
                                "phone": "+1-234-567-8900"
                            }
                        }
                    ],
                    "address": {
                        "street": "123 Tech Street",
                        "city": "San Francisco",
                        "state": "CA",
                        "zip": "94105"
                    }
                }
            }
            """
        }
    }
}

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
