//
//  NetworkService.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

class NetworkService {
    static func makeRequest(
        url: URL,
        method: HTTPMethod,
        headers: [Header],
        body: String?
    ) async throws -> APIResponse {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let body = body {
            request.httpBody = body.data(using: .utf8)
        }
        
        let startTime = Date()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let responseTime = Date().timeIntervalSince(startTime)
        
        return APIResponse(
            statusCode: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields as? [String: String] ?? [:],
            body: String(data: data, encoding: .utf8) ?? "",
            responseTime: responseTime
        )
    }
}
