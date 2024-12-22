//
//  RegexTesterView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct RegexTesterView: View {
    @StateObject private var viewModel = RegexViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case pattern, testString
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Pattern Input
                    VStack(alignment: .leading) {
                        Text("Regular Expression Pattern")
                            .font(.headline)
                        TextField("Enter pattern", text: $viewModel.pattern)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .pattern)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    // Test String Input
                    VStack(alignment: .leading) {
                        Text("Test String")
                            .font(.headline)
                        TextEditor(text: $viewModel.testString)
                            .frame(height: 100)
                            .focused($focusedField, equals: .testString)
                            .border(Color.gray, width: 1)
                    }
                    
                    // Options
                    RegexOptionsView(options: $viewModel.options)
                    
                    // Test Button
                    Button("Test Regex") {
                        Task {
                            await viewModel.performMatch()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Matches Display
                    VStack(alignment: .leading) {
                        Text("Matches")
                            .font(.headline)
                        
                        if viewModel.matches.isEmpty {
                            Text("No matches found")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.matches, id: \.self) { match in
                                Text(match)
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Regex Tester")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text(alertItem.dismissButton))
                )
            }
            .addKeyboardToolbar() // Only add keyboard toolbar here at the root level
        }
    }
}

// Preview
/*#Preview {
    RegexTesterView()
}*/
