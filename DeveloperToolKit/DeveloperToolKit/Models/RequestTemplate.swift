//
//  RequestTemplate.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import Foundation

struct RequestTemplate: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var category: String
    var request: TemplateRequest
    
    struct TemplateRequest: Codable {
        var url: String
        var method: String // Changed from RequestMethod to String for Codable
        var headers: [[String: String]] // Changed from [Header] to [[String: String]] for Codable
        var body: String
        
        // Add coding keys if needed
        enum CodingKeys: String, CodingKey {
            case url
            case method
            case headers
            case body
        }
    }
    
    static let samples: [RequestTemplate] = [
        // Authentication
        RequestTemplate(
            id: UUID(),
            name: "Login",
            description: "Basic authentication request",
            category: "Authentication",
            request: TemplateRequest(
                url: "https://api.example.com/login",
                method: "POST",
                headers: [
                    ["key": "Content-Type", "value": "application/json"]
                ],
                body: """
                {
                    "username": "user@example.com",
                    "password": "password123"
                }
                """
            )
        ),
        
        // CRUD Operations
        RequestTemplate(
            id: UUID(),
            name: "Get Users",
            description: "Fetch list of users",
            category: "CRUD",
            request: TemplateRequest(
                url: "https://api.example.com/users",
                method: "GET",
                headers: [
                    ["key": "Authorization", "value": "Bearer {token}"]
                ],
                body: ""
            )
        ),
        
        // File Operations
        RequestTemplate(
            id: UUID(),
            name: "Upload File",
            description: "Upload file with multipart form data",
            category: "Files",
            request: TemplateRequest(
                url: "https://api.example.com/upload",
                method: "POST",
                headers: [
                    ["key": "Content-Type", "value": "multipart/form-data"]
                ],
                body: "// Multipart form data body"
            )
        )
    ]
}
