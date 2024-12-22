//
//  JSONFormatterComponents.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

/*import SwiftUI
import UIKit

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
        Text(json)
            .textSelection(.enabled)
            .padding(8)
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

#Preview {
    ActionButton(title: "Format", icon: "arrow.right.circle.fill") { }
}
*/
