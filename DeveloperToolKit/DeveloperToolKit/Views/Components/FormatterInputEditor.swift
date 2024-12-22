//
//  FormatterInputEditor.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct FormatterInputEditor: View {
    @Binding var text: String
    let isError: Bool
    let focused: FocusState<FormatterField?>.Binding
    let field: FormatterField
    
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
