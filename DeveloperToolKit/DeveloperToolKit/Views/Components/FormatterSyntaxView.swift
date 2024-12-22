//
//  FormatterSyntaxView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct FormatterSyntaxView: View {
    let json: String
    @State private var showLineNumbers = true
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(alignment: .top, spacing: 0) {
                if showLineNumbers {
                    lineNumbers
                }
                highlightedText
            }
        }
        .frame(height: 200)
        .font(.system(.body, design: .monospaced))
    }
    
    private var lineNumbers: some View {
        let lines = json.components(separatedBy: .newlines)
        return VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<lines.count, id: \.self) { index in
                Text("\(index + 1)")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
    }
    
    private var highlightedText: some View {
        Text(json)
            .textSelection(.enabled)
            .padding(8)
    }
}
