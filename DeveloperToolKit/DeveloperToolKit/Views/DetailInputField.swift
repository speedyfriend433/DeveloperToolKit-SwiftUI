//
//  DetailInputField.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct DetailInputField: View {
    let title: String
    let text: Binding<String>
    let icon: String
    let focused: FocusState<FormField?>.Binding
    let field: FormField
    
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

struct DetailInputField_Previews: PreviewProvider {
    @FocusState static var focus: FormField?
    
    static var previews: some View {
        DetailInputField(
            title: "Example Field",
            text: .constant("Example Text"),
            icon: "text.alignleft",
            focused: $focus,
            field: .title
        )
        .padding()
    }
}
