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
                VStack(spacing: 20) {
                    patternSection
                    optionsSection
                    testStringSection
                    matchesSection
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Regex Tester")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.showSamples = true
                        } label: {
                            Label("Sample Patterns", systemImage: "text.magnifyingglass")
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
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSamples) {
                RegexSamplesView(viewModel: viewModel)
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text(alertItem.dismissButton))
                )
            }
        }
    }
    
    private var patternSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pattern")
                .font(.headline)
            
            TextField("Enter regex pattern", text: $viewModel.pattern)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .pattern)
            
            Button {
                Task {
                    await viewModel.performMatch()
                }
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Test Pattern")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.primary)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
    
    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Options")
                .font(.headline)
            
            VStack(spacing: 12) {
                OptionToggle(
                    title: "Case Insensitive",
                    icon: "textformat.size",
                    isOn: $viewModel.options.caseInsensitive
                )
                
                OptionToggle(
                    title: "Multiline",
                    icon: "text.alignleft",
                    isOn: $viewModel.options.multiline
                )
                
                OptionToggle(
                    title: "Dot Matches All",
                    icon: "circle.dotted",
                    isOn: $viewModel.options.dotMatchesAll
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var testStringSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Test String")
                .font(.headline)
            
            TextEditor(text: $viewModel.testString)
                .frame(height: 100)
                .focused($focusedField, equals: .testString)
                .padding(8)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2))
                )
        }
    }
    
    private var matchesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Matches")
                .font(.headline)
            
            if viewModel.matches.isEmpty {
                Text("No matches found")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.matches, id: \.self) { match in
                            HStack {
                                Text(match)
                                    .font(.system(.body, design: .monospaced))
                                
                                Spacer()
                                
                                Button {
                                    UIPasteboard.general.string = match
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(Theme.primary)
                                }
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct OptionToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Theme.primary)
                Text(title)
            }
        }
    }
}

#Preview {
    RegexTesterView()
}
