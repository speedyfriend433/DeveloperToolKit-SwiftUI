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
    @State private var showingSampleSheet = false
    
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
                        buttonSection // New combined button section
                        matchesSection
                    }
                    .padding()
                }
                .background(Theme.background)
                .navigationTitle("Regex Tester")
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert(
                        title: Text(alertItem.title),
                        message: Text(alertItem.message),
                        dismissButton: .default(Text(alertItem.dismissButton))
                    )
                }
                .sheet(isPresented: $showingSampleSheet) {
                    SamplePatternsView(viewModel: viewModel)
                }
                .addKeyboardToolbar()
            }
        }
    
    private var patternSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Regular Expression Pattern")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Button(action: { viewModel.pattern = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.text.opacity(0.5))
                }
                .opacity(viewModel.pattern.isEmpty ? 0 : 1)
            }
            
            TextField("Enter pattern", text: $viewModel.pattern)
                .textFieldStyle(ModernTextFieldStyle())
                .focused($focusedField, equals: .pattern)
                .font(.system(.body, design: .monospaced))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Options")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            VStack(spacing: 8) {
                OptionToggle(isOn: $viewModel.options.caseInsensitive,
                            title: "Case Insensitive",
                            icon: "textformat.abc")
                
                OptionToggle(isOn: $viewModel.options.multiline,
                            title: "Multi-line",
                            icon: "text.alignleft")
                
                OptionToggle(isOn: $viewModel.options.dotMatchesAll,
                            title: "Dot Matches All",
                            icon: "circle.dotted")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var testStringSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Test String")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Button(action: { viewModel.testString = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.text.opacity(0.5))
                }
                .opacity(viewModel.testString.isEmpty ? 0 : 1)
            }
            
            TextEditor(text: $viewModel.testString)
                .frame(height: 120)
                .focused($focusedField, equals: .testString)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
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
                // Sample Patterns Button
                Button {
                    showingSampleSheet = true
                } label: {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Samples")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.secondary)
                            .shadow(color: Theme.secondary.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
                }
                
                // Test Button
                Button {
                    Task {
                        await viewModel.performMatch()
                    }
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Test")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.primary)
                            .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 2)
                    )
                }
            }
        }
    
    private var matchesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Matches")
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                if !viewModel.matches.isEmpty {
                    Text("\(viewModel.matches.count) matches found")
                        .font(.caption)
                        .foregroundColor(Theme.text.opacity(0.5))
                }
            }
            
            if viewModel.matches.isEmpty {
                emptyMatchesView
            } else {
                matchesList
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var emptyMatchesView: some View {
        VStack(spacing: 12) {
            Image(systemName: "text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(Theme.primary.opacity(0.3))
            
            Text("No matches found")
                .font(.subheadline)
                .foregroundColor(Theme.text.opacity(0.5))
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
    
    private var matchesList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(viewModel.matches, id: \.self) { match in
                    MatchRow(match: match)
                }
            }
        }
        .frame(maxHeight: 200)
    }
}

struct OptionToggle: View {
    @Binding var isOn: Bool
    let title: String
    let icon: String
    
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Theme.primary)
                Text(title)
                    .foregroundColor(Theme.text)
            }
        }
        .tint(Theme.primary)
    }
}

struct MatchRow: View {
    let match: String
    
    var body: some View {
        HStack {
            Text(match)
                .font(.system(.body, design: .monospaced))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
            
            Spacer()
            
            Button {
                UIPasteboard.general.string = match
            } label: {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(Theme.primary)
            }
        }
        .background(Theme.background)
        .cornerRadius(8)
    }
}

struct SamplePatternsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RegexViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(SamplePattern.samples) { sample in
                    SamplePatternRow(sample: sample)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.pattern = sample.pattern
                            viewModel.testString = sample.sampleText
                            dismiss()
                        }
                }
            }
            .navigationTitle("Sample Patterns")
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

struct SamplePatternRow: View {
    let sample: SamplePattern
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sample.name)
                .font(.headline)
                .foregroundColor(Theme.text)
            
            Text(sample.description)
                .font(.subheadline)
                .foregroundColor(Theme.text.opacity(0.7))
            
            Text(sample.pattern)
                .font(.system(.caption, design: .monospaced))
                .padding(6)
                .background(Theme.background)
                .cornerRadius(6)
            
            Text("Example: \(sample.sampleText)")
                .font(.caption)
                .foregroundColor(Theme.text.opacity(0.5))
        }
        .padding(.vertical, 4)
    }
}

// Preview
#Preview {
    RegexTesterView()
}
