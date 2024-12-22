//
//  SnippetModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct SnippetModel: Identifiable, Hashable {
    let id: UUID
    var title: String
    var code: String
    var language: String
    var tags: [String]
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SnippetModel, rhs: SnippetModel) -> Bool {
        lhs.id == rhs.id
    }
}