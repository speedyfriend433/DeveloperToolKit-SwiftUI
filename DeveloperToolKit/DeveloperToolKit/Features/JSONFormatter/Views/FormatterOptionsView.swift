//
//  FormatterOptionsView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct FormatterOptionsView: View {
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
