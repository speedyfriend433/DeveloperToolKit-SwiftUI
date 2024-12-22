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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showOptions = true
                        } label: {
                            Label("Formatting Options", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showOptions) {
                FormatterOptionsView(options: $viewModel.options)
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
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Input JSON")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Button(action: { viewModel.inputJSON = "" }) {
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
        }
    }
    
    private var toolbarSection: some View {
        HStack(spacing: 16) {
            ForEach([
                ("Format", "arrow.right.circle.fill", viewModel.formatJSON),
                ("Minify", "arrow.left.circle.fill", viewModel.minifyJSON),
                ("Copy", "doc.on.doc.fill", viewModel.copyToClipboard)
            ], id: \.0) { title, icon, action in
                FormatterButton(title: title, icon: icon, action: action)
            }
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
                TextEditor(text: .constant(viewModel.formattedJSON))
                    .frame(height: 200)
                    .font(.system(.body, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            }
        }
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

struct FormatterButton: View {
    let title: String
    let icon: String
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
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

#Preview {
    JSONFormatterView()
}

#Preview {
    JSONFormatterView()
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
