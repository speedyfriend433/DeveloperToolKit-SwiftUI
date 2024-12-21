//
//  Models.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

enum HTTPMethod: String, CaseIterable, Identifiable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var id: String { self.rawValue }
}

struct Header: Identifiable {
    let id = UUID()
    var key: String
    var value: String
}

struct APIResponse: Identifiable {
    let id = UUID()
    var statusCode: Int
    var headers: [String: String]
    var body: String
    var responseTime: TimeInterval
}

struct CodeSnippet: Codable, Identifiable {
    let id: UUID
    var title: String
    var code: String
    var language: String
    var tags: [String]
    var dateCreated: Date
}
