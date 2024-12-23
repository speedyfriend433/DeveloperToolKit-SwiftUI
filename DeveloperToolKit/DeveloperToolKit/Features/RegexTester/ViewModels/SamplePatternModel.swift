//
//  SamplePatternModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct RegexSamplesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RegexViewModel
    
    let samples: [(category: String, patterns: [RegexPattern])] = [
        (
            "Email & Web",
            [
                RegexPattern(
                    name: "Email Address",
                    pattern: "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
                    description: "Matches valid email addresses",
                    testString: """
                    test@example.com
                    john.doe@company.co.uk
                    invalid.email@
                    """,
                    examples: ["test@example.com", "john.doe@company.co.uk"]
                ),
                RegexPattern(
                    name: "URL",
                    pattern: "https?://[\\w\\d\\-._~:/?#\\[\\]@!$&'()*+,;=.]+",
                    description: "Matches web URLs",
                    testString: """
                    https://www.example.com
                    http://github.com
                    https://api.github.com/users
                    """,
                    examples: ["https://www.google.com", "http://localhost:3000"]
                )
            ]
        ),
        (
            "Numbers & Dates",
            [
                RegexPattern(
                    name: "Date (YYYY-MM-DD)",
                    pattern: "\\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01])",
                    description: "Matches dates in YYYY-MM-DD format",
                    testString: """
                    2024-01-23
                    2023-12-31
                    2024-13-45
                    """,
                    examples: ["2024-01-01", "2023-12-31"]
                ),
                RegexPattern(
                    name: "Time (HH:MM)",
                    pattern: "([01]\\d|2[0-3]):[0-5]\\d",
                    description: "Matches 24-hour time format",
                    testString: """
                    13:45
                    09:30
                    25:00
                    """,
                    examples: ["13:45", "09:30", "23:59"]
                ),
                RegexPattern(
                    name: "Phone Number",
                    pattern: "\\(\\d{3}\\)\\s?\\d{3}-\\d{4}|\\d{3}-\\d{3}-\\d{4}",
                    description: "Matches US phone numbers",
                    testString: """
                    123-456-7890
                    (123) 456-7890
                    1234567890
                    """,
                    examples: ["123-456-7890", "(123) 456-7890"]
                )
            ]
        ),
        (
            "Code & Variables",
            [
                RegexPattern(
                    name: "Variable Name",
                    pattern: "[a-zA-Z_$][a-zA-Z0-9_$]*",
                    description: "Matches valid variable names",
                    testString: """
                    myVariable
                    _privateVar
                    $specialVar
                    123invalid
                    """,
                    examples: ["myVariable", "_privateVar", "$price"]
                ),
                RegexPattern(
                    name: "Hex Color",
                    pattern: "#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})",
                    description: "Matches hex color codes",
                    testString: """
                    #FF5733
                    #FFF
                    #XYZ
                    """,
                    examples: ["#FF5733", "#FFF", "#123456"]
                )
            ]
        ),
        (
            "Text Validation",
            [
                RegexPattern(
                    name: "Strong Password",
                    pattern: "(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}",
                    description: "At least 8 chars, 1 letter, 1 number, 1 special char",
                    testString: """
                    Password123!
                    WeakPwd1
                    StrongP@ssw0rd
                    """,
                    examples: ["StrongP@ssw0rd", "Pass123$word"]
                ),
                RegexPattern(
                    name: "Username",
                    pattern: "[a-zA-Z0-9_-]{3,16}",
                    description: "3-16 chars, letters, numbers, _ and -",
                    testString: """
                    john_doe
                    user123
                    a
                    very_long_username_123
                    """,
                    examples: ["john_doe", "user123", "admin"]
                )
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(samples, id: \.category) { section in
                    Section(header: Text(section.category)) {
                        ForEach(section.patterns) { pattern in
                            PatternCard(pattern: pattern)
                                .listRowInsets(EdgeInsets())
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    viewModel.pattern = pattern.pattern
                                    viewModel.testString = pattern.testString
                                    dismiss()
                                }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
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

struct PatternCard: View {
    let pattern: RegexPattern
    @State private var showingExamples = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(pattern.name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Button {
                    UIPasteboard.general.string = pattern.pattern
                } label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(Theme.primary)
                }
            }
            
            // Description
            Text(pattern.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Pattern
            Text(pattern.pattern)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            
            // Examples Toggle
            DisclosureGroup(
                isExpanded: $showingExamples,
                content: {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(pattern.examples, id: \.self) { example in
                            Text(example)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                },
                label: {
                    Text("Examples")
                        .font(.caption)
                        .foregroundColor(Theme.primary)
                }
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    RegexSamplesView(viewModel: RegexViewModel())
}
