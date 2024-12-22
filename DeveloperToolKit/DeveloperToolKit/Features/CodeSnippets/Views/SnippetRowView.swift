//
//  SnippetRowView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SnippetRowView: View {
    let snippet: SnippetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Language
            HStack {
                Text(snippet.title)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Text(snippet.language)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primary.opacity(0.1))
                    .foregroundColor(Theme.primary)
                    .cornerRadius(8)
            }
            
            // Preview of code
            Text(snippet.code.prefix(100) + (snippet.code.count > 100 ? "..." : ""))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(Theme.text.opacity(0.7))
                .lineLimit(2)
            
            // Tags
            if !snippet.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(snippet.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.secondary.opacity(0.1))
                                .foregroundColor(Theme.secondary)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Date
            Text(snippet.dateCreated.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(Theme.text.opacity(0.5))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
