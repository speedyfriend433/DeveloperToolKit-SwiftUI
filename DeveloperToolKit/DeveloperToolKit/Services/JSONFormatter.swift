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
        
        let object = try JSONSerialization.jsonObject(with: data)
        var writingOptions: JSONSerialization.WritingOptions = [.prettyPrinted]
        
        if options.sortKeys {
            writingOptions.insert(.sortedKeys)
        }
        if !options.escapeSlashes {
            writingOptions.insert(.withoutEscapingSlashes)
        }
        
        let prettyData = try JSONSerialization.data(
            withJSONObject: object,
            options: writingOptions
        )
        
        var prettyString = String(data: prettyData, encoding: .utf8) ?? ""
        
        // Apply custom formatting
        if options.useTabs {
            prettyString = prettyString.replacingOccurrences(
                of: String(repeating: " ", count: 2),
                with: "\t"
            )
        } else if options.indentationSpaces != 2 {
            prettyString = prettyString.replacingOccurrences(
                of: String(repeating: " ", count: 2),
                with: String(repeating: " ", count: options.indentationSpaces)
            )
        }
        
        if options.quoteStyle == .single {
            prettyString = prettyString.replacingOccurrences(of: "\"", with: "'")
        }
        
        if !options.spaceAfterColon {
            prettyString = prettyString.replacingOccurrences(of: ": ", with: ":")
        }
        
        if options.spaceInsideBrackets {
            prettyString = prettyString.replacingOccurrences(of: "[", with: "[ ")
            prettyString = prettyString.replacingOccurrences(of: "]", with: " ]")
        }
        
        if options.spaceInsideBraces {
            prettyString = prettyString.replacingOccurrences(of: "{", with: "{ ")
            prettyString = prettyString.replacingOccurrences(of: "}", with: " }")
        }
        
        if options.trailingCommas {
            prettyString = addTrailingCommas(to: prettyString)
        }
        
        return prettyString
    }
    
    private static func addTrailingCommas(to json: String) -> String {
        let lines = json.components(separatedBy: .newlines)
        var result: [String] = []
        var bracketStack: [Character] = []
        
        for (index, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            var modifiedLine = line
            
            // Track brackets and braces
            if let lastChar = trimmedLine.last {
                if lastChar == "{" || lastChar == "[" {
                    bracketStack.append(lastChar)
                } else if lastChar == "}" || lastChar == "]" {
                    if !bracketStack.isEmpty {
                        bracketStack.removeLast()
                    }
                }
            }
            
            // Check if we need to add a comma
            if !bracketStack.isEmpty && index < lines.count - 1 {
                let nextLine = lines[index + 1].trimmingCharacters(in: .whitespaces)
                let nextLineFirstChar = nextLine.first ?? " "
                
                if shouldAddComma(to: trimmedLine) &&
                   !["}", "]", ","].contains(nextLineFirstChar) {
                    modifiedLine = addComma(to: line)
                }
            }
            
            result.append(modifiedLine)
        }
        
        return result.joined(separator: "\n")
    }
    
    private static func shouldAddComma(to line: String) -> Bool {
        // Skip empty lines
        guard !line.isEmpty else { return false }
        
        // Skip lines that already end with a comma
        guard !line.hasSuffix(",") else { return false }
        
        // Skip lines that end with opening brackets
        guard !line.hasSuffix("{") && !line.hasSuffix("[") else { return false }
        
        // Check if line ends with a value
        let valuePatterns = [
            #"\"[^\"]*\"$"#,          // String
            #"\d+\.?\d*$"#,           // Number
            #"true$|false$|null$"#,   // Boolean or null
            #"\}$|\]$"#               // Closing bracket
        ]
        
        return valuePatterns.contains { pattern in
            line.range(of: pattern, options: .regularExpression) != nil
        }
    }
    
    private static func addComma(to line: String) -> String {
        if let lastNonWhitespace = line.lastIndex(where: { !$0.isWhitespace }) {
            let index = line.index(after: lastNonWhitespace)
            return line[..<index] + "," + line[index...]
        }
        return line
    }
    
    static func minify(_ json: String) throws -> String {
        guard let data = json.data(using: .utf8) else {
            throw JSONError.invalidInput
        }
        
        let object = try JSONSerialization.jsonObject(with: data)
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

#if DEBUG
// Example usage and tests
extension JSONFormatter {
    static var examples: [(String, String)] {
        [
            ("Simple Object", """
            {
                "name": "John",
                "age": 30
            }
            """),
            
            ("Nested Object", """
            {
                "person": {
                    "name": "John",
                    "age": 30
                },
                "active": true
            }
            """),
            
            ("Array", """
            {
                "numbers": [
                    1,
                    2,
                    3
                ],
                "active": true
            }
            """)
        ]
    }
}
#endif
