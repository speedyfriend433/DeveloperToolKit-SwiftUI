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
        var method: String
        var headers: [[String: String]]
        var body: String
        
        enum CodingKeys: String, CodingKey {
            case url
            case method
            case headers
            case body
        }
    }
    
    static let samples: [RequestTemplate] = [

        RequestTemplate(
            id: UUID(),
            name: "Get Random User",
            description: "Fetch random user data",
            category: "Public APIs",
            request: TemplateRequest(
                url: "https://randomuser.me/api/",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Get Random Joke",
            description: "Fetch a random Chuck Norris joke",
            category: "Public APIs",
            request: TemplateRequest(
                url: "https://api.chucknorris.io/jokes/random",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Get Current Weather",
            description: "Get weather for London (OpenWeatherMap)",
            category: "Weather",
            request: TemplateRequest(
                url: "https://api.openweathermap.org/data/2.5/weather?q=London&appid=c40fdb07dad7a0f2a474ef8d79b9a386",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Get GitHub User",
            description: "Fetch GitHub user profile",
            category: "GitHub",
            request: TemplateRequest(
                url: "https://api.github.com/users/octocat",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/vnd.github.v3+json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "List GitHub Repos",
            description: "List public repositories for a user",
            category: "GitHub",
            request: TemplateRequest(
                url: "https://api.github.com/users/octocat/repos",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/vnd.github.v3+json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Get Posts",
            description: "Fetch sample posts from JSONPlaceholder",
            category: "Testing",
            request: TemplateRequest(
                url: "https://jsonplaceholder.typicode.com/posts",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Create Post",
            description: "Create a new post (Test API)",
            category: "Testing",
            request: TemplateRequest(
                url: "https://jsonplaceholder.typicode.com/posts",
                method: "POST",
                headers: [
                    ["key": "Content-Type", "value": "application/json"],
                    ["key": "Accept", "value": "application/json"]
                ],
                body: """
                {
                    "title": "Test Post",
                    "body": "This is a test post body",
                    "userId": 1
                }
                """
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "OAuth Token Request",
            description: "Example OAuth token request",
            category: "Auth",
            request: TemplateRequest(
                url: "https://oauth2.example.com/token",
                method: "POST",
                headers: [
                    ["key": "Content-Type", "value": "application/x-www-form-urlencoded"],
                    ["key": "Authorization", "value": "Basic {base64_encoded_credentials}"]
                ],
                body: "grant_type=client_credentials&scope=read_write"
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Get Country Info",
            description: "Get information about countries",
            category: "Public APIs",
            request: TemplateRequest(
                url: "https://restcountries.com/v3.1/name/france",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        ),
        
        RequestTemplate(
            id: UUID(),
            name: "Random Dog Image",
            description: "Get a random dog image",
            category: "Public APIs",
            request: TemplateRequest(
                url: "https://dog.ceo/api/breeds/image/random",
                method: "GET",
                headers: [
                    ["key": "Accept", "value": "application/json"]
                ],
                body: ""
            )
        )
    ]
}
