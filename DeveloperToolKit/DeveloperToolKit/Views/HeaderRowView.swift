//
//  HeaderRowView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct HeaderRowView: View {
    @Binding var header: Header
    let onDelete: () -> Void
    @FocusState private var focusedField: Field?
    
    enum Field {
        case key, value
    }
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Key", text: Binding(
                get: { header.key },
                set: { header.key = $0 }
            ))
            .textFieldStyle(ModernTextFieldStyle())
            .focused($focusedField, equals: .key)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            
            TextField("Value", text: Binding(
                get: { header.value },
                set: { header.value = $0 }
            ))
            .textFieldStyle(ModernTextFieldStyle())
            .focused($focusedField, equals: .value)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            
            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(Theme.error)
                    .font(.title2)
            }
        }
    }
}

#Preview {
    HeaderRowView(
        header: .constant(Header(key: "Content-Type", value: "application/json")),
        onDelete: {}
    )
    .padding()
}
