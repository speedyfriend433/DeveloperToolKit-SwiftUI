//
//  APIResponse.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct APIResponse: Identifiable {
    let id = UUID()
    var statusCode: Int
    var headers: [String: String]
    var body: String
    var responseTime: TimeInterval
}
