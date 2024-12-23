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
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Category Selector
                    categoryPicker
                    
                    // Content
                    content
                        .animation(.easeInOut, value: selectedTab)
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Formatting Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        options = JSONFormatterOptions()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .foregroundColor(Theme.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.title,
                        icon: category.icon,
                        isSelected: selectedTab == category.rawValue
                    ) {
                        selectedTab = category.rawValue
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var content: some View {
        VStack(spacing: 20) {
            switch Category(rawValue: selectedTab) ?? .indentation {
            case .indentation: indentationSection
            case .formatting: formattingSection
            case .arrays: arraySection
            case .strings: stringSection
            case .spacing: spacingSection
            }
        }
    }
    
    private var indentationSection: some View {
        SettingsCard {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Use Tabs",
                    subtitle: "Use tabs instead of spaces for indentation",
                    isOn: $options.useTabs
                )
                
                if !options.useTabs {
                    SettingsStepper(
                        title: "Indentation Spaces",
                        value: $options.indentationSpaces,
                        range: 1...8,
                        format: { "\($0) spaces" }
                    )
                }
            }
        }
    }
    
    private var formattingSection: some View {
        VStack(spacing: 20) {
            SettingsCard {
                VStack(spacing: 16) {
                    SettingsToggle(
                        title: "Sort Keys",
                        subtitle: "Sort object keys alphabetically",
                        isOn: $options.sortKeys
                    )
                    
                    SettingsToggle(
                        title: "Line Wrapping",
                        subtitle: "Wrap long lines to improve readability",
                        isOn: $options.lineWrapping
                    )
                }
            }
            
            if options.lineWrapping {
                SettingsCard {
                    SettingsStepper(
                        title: "Maximum Line Length",
                        value: $options.maxLineLength,
                        range: 40...200,
                        step: 20,
                        format: { "\($0) characters" }
                    )
                }
            }
        }
    }
    
    private var arraySection: some View {
        VStack(spacing: 20) {
            SettingsCard {
                SettingsSegmentedPicker(
                    title: "Array Wrapping",
                    selection: $options.arrayWrapping,
                    options: JSONFormatterOptions.ArrayWrappingStyle.allCases
                )
            }
            
            if options.arrayWrapping == .all {
                SettingsCard {
                    SettingsStepper(
                        title: "Items Per Line",
                        value: $options.arrayItemsPerLine,
                        range: 1...10,
                        format: { "\($0) items" }
                    )
                }
            }
        }
    }
    
    private var stringSection: some View {
        SettingsCard {
            VStack(spacing: 16) {
                SettingsSegmentedPicker(
                    title: "Quote Style",
                    selection: $options.quoteStyle,
                    options: JSONFormatterOptions.QuoteStyle.allCases
                )
                
                SettingsToggle(
                    title: "Escape Slashes",
                    subtitle: "Escape forward slashes in strings",
                    isOn: $options.escapeSlashes
                )
                
                SettingsToggle(
                    title: "Escape Unicode",
                    subtitle: "Escape Unicode characters",
                    isOn: $options.escapeUnicode
                )
            }
        }
    }
    
    private var spacingSection: some View {
        SettingsCard {
            VStack(spacing: 16) {
                SettingsToggle(
                    title: "Space After Colon",
                    subtitle: "Add space after colons",
                    isOn: $options.spaceAfterColon
                )
                
                SettingsToggle(
                    title: "Space Inside Brackets",
                    subtitle: "Add spaces inside array brackets",
                    isOn: $options.spaceInsideBrackets
                )
                
                SettingsToggle(
                    title: "Space Inside Braces",
                    subtitle: "Add spaces inside object braces",
                    isOn: $options.spaceInsideBraces
                )
                
                SettingsToggle(
                    title: "Trailing Commas",
                    subtitle: "Add commas after last items",
                    isOn: $options.trailingCommas
                )
            }
        }
    }
}

// MARK: - Supporting Views
private struct CategoryButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : Theme.text)
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Theme.primary : Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

private struct SettingsCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private struct SettingsToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

private struct SettingsStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    var step: Int = 1
    let format: (Int) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            HStack {
                Text(format(value))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Stepper("", value: $value, in: range, step: step)
                    .labelsHidden()
            }
        }
    }
}

private struct SettingsSegmentedPicker<T: Hashable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

// MARK: - Supporting Types
private enum Category: Int, CaseIterable {
    case indentation, formatting, arrays, strings, spacing
    
    var title: String {
        switch self {
        case .indentation: return "Indent"
        case .formatting: return "Format"
        case .arrays: return "Arrays"
        case .strings: return "Strings"
        case .spacing: return "Spacing"
        }
    }
    
    var icon: String {
        switch self {
        case .indentation: return "arrow.right.to.line"
        case .formatting: return "text.alignleft"
        case .arrays: return "list.bullet"
        case .strings: return "quotemark"
        case .spacing: return "arrow.left.and.right"
        }
    }
}

#Preview {
    FormatterOptionsView(options: .constant(JSONFormatterOptions()))
}
