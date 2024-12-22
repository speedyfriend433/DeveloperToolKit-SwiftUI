//
//  JSONFormatter.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

enum JSONFormatter {
    static func format(_ json: String, options: JSONFormatterOptions) throws -> String {
        guard let data = json.data(using: .utf8) else {
            throw JSONError.invalidInput
        }
        
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        var writingOptions: JSONSerialization.WritingOptions = [.prettyPrinted]
        
        if options.sortKeys {
            writingOptions.insert(.sortedKeys)
        }
        if options.escapeSlashes {
            writingOptions.insert(.withoutEscapingSlashes)
        }
        
        let prettyData = try JSONSerialization.data(
            withJSONObject: object,
            options: writingOptions
        )
        
        var prettyString = String(data: prettyData, encoding: .utf8) ?? ""
        
        // Apply custom indentation
        if options.indentationSpaces != 2 {
            let defaultIndentation = String(repeating: " ", count: 2)
            let customIndentation = String(repeating: " ", count: options.indentationSpaces)
            prettyString = prettyString.replacingOccurrences(
                of: defaultIndentation,
                with: customIndentation
            )
        }
        
        return prettyString
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
