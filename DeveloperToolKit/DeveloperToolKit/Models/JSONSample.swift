//
//  JSONSample.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

// MARK: - Sample JSON

import Foundation

enum JSONSample: String, CaseIterable, Identifiable {
    case simple
    case nested
    case array
    case complex
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .simple: return "Simple Object"
        case .nested: return "Nested Object"
        case .array: return "Array"
        case .complex: return "Complex Object"
        }
    }
    
    var description: String {
        switch self {
        case .simple: return "Basic key-value pairs"
        case .nested: return "Object with nested objects"
        case .array: return "Array of objects"
        case .complex: return "Complex nested structure"
        }
    }
    
    var json: String {
        switch self {
        case .simple:
            return """
            {
                "name": "John Doe",
                "age": 30,
                "city": "New York"
            }
            """
        case .nested:
            return """
            {
                "person": {
                    "name": "John Doe",
                    "address": {
                        "street": "123 Main St",
                        "city": "New York",
                        "country": "USA"
                    }
                }
            }
            """
        case .array:
            return """
            {
                "people": [
                    {
                        "name": "John",
                        "age": 30
                    },
                    {
                        "name": "Jane",
                        "age": 25
                    }
                ]
            }
            """
        case .complex:
            return """
            {
                "company": {
                    "name": "Tech Corp",
                    "employees": [
                        {
                            "id": 1,
                            "name": "John Doe",
                            "position": "Developer",
                            "skills": ["Swift", "iOS", "SwiftUI"],
                            "contact": {
                                "email": "john@example.com",
                                "phone": "+1-234-567-8900"
                            }
                        }
                    ],
                    "address": {
                        "street": "123 Tech Street",
                        "city": "San Francisco",
                        "state": "CA",
                        "zip": "94105"
                    }
                }
            }
            """
        }
    }
}
