//
//  SamplePatternModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct SamplePattern: Identifiable {
    let id = UUID()
    let name: String
    let pattern: String
    let description: String
    let sampleText: String
    
    static let samples: [SamplePattern] = [
        SamplePattern(
            name: "Email",
            pattern: #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#,
            description: "Matches valid email addresses",
            sampleText: "test@example.com"
        ),
        SamplePattern(
            name: "Phone Number",
            pattern: #"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$"#,
            description: "Matches US phone numbers in various formats",
            sampleText: "123-456-7890"
        ),
        SamplePattern(
            name: "URL",
            pattern: #"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)"#,
            description: "Matches web URLs",
            sampleText: "https://www.example.com"
        ),
        SamplePattern(
            name: "Date (YYYY-MM-DD)",
            pattern: #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$"#,
            description: "Matches dates in YYYY-MM-DD format",
            sampleText: "2024-01-31"
        ),
        SamplePattern(
            name: "Strong Password",
            pattern: #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"#,
            description: "Minimum 8 characters, at least one letter, one number, and one special character",
            sampleText: "Password123!"
        ),
        SamplePattern(
            name: "IP Address",
            pattern: #"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"#,
            description: "Matches IPv4 addresses",
            sampleText: "192.168.1.1"
        ),
        SamplePattern(
            name: "Credit Card",
            pattern: #"^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9][0-9])[0-9]{12})$"#,
            description: "Matches major credit card numbers",
            sampleText: "4111111111111111"
        ),
        SamplePattern(
            name: "Hex Color",
            pattern: #"^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"#,
            description: "Matches hex color codes",
            sampleText: "#FF5733"
        )
    ]
}
