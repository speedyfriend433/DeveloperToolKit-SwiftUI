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
    
    var body: some View {
        HStack {
            TextField("Key", text: Binding(
                get: { header.key },
                set: { header.key = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            
            Text(":")
            
            TextField("Value", text: Binding(
                get: { header.value },
                set: { header.value = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            
            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
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
