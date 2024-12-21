//
//  JSONFormatterView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct JSONFormatterView: View {
    @StateObject private var viewModel = JSONFormatterViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Input JSON")
                        .font(.headline)
                    TextEditor(text: $viewModel.inputJSON)
                        .font(.system(.body, design: .monospaced))
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .border(Color.gray, width: 1)
                }
                
                VStack(alignment: .leading) {
                    Text("Formatted Output")
                        .font(.headline)
                    TextEditor(text: .constant(viewModel.formattedJSON))
                        .font(.system(.body, design: .monospaced))
                        .frame(height: UIScreen.main.bounds.height * 0.3)
                        .border(Color.gray, width: 1)
                }
                
                HStack {
                    Button("Format") {
                        viewModel.formatJSON()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Minify") {
                        viewModel.minifyJSON()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Copy") {
                        viewModel.copyToClipboard()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
            .navigationTitle("JSON Formatter")
        }
    }
}
