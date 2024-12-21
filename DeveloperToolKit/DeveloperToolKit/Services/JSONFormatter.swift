//
//  JSONFormatter.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

class JSONFormatter {
    static func format(_ json: String) throws -> String {
        guard let data = json.data(using: .utf8) else {
            throw JSONError.invalidInput
        }
        
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        let prettyData = try JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted]
        )
        
        return String(data: prettyData, encoding: .utf8) ?? ""
    }
    
    static func minify(_ json: String) throws -> String {
        guard let data = json.data(using: .utf8) else {
            throw JSONError.invalidInput
        }
        
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        let minifiedData = try JSONSerialization.data(
            withJSONObject: object,
            options: []
        )
        
        return String(data: minifiedData, encoding: .utf8) ?? ""
    }
}

enum JSONError: Error {
    case invalidInput
}
