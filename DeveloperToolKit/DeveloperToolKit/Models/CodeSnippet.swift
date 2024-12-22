//
//  CodeSnippet.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct CodeSnippet: Identifiable, Hashable {
    let id: UUID
    var title: String
    var code: String
    var language: String
    var tags: [String]
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CodeSnippet, rhs: CodeSnippet) -> Bool {
        lhs.id == rhs.id
    }
}
