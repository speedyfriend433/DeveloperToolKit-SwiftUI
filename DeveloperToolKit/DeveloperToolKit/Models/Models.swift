//
//  Models.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct CodeSnippet: Codable, Identifiable {
    let id: UUID
    var title: String
    var code: String
    var language: String
    var tags: [String]
    var dateCreated: Date
}
