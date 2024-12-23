//
//  SnippetInputField.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct SnippetInputField: View {
    let title: String
    let text: Binding<String>
    let icon: String
    let focused: FocusState<SnippetDetailView.Field?>.Binding
    let field: SnippetDetailView.Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(Theme.text)
            
            TextField(title, text: text)
                .textFieldStyle(ModernTextFieldStyle())
                .focused(focused, equals: field)
        }
    }
}
