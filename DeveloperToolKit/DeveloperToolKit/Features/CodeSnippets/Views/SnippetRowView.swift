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
        VStack(alignment: .leading) {
            Text(snippet.title)
                .font(.headline)
            Text(snippet.language)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if !snippet.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(snippet.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}
