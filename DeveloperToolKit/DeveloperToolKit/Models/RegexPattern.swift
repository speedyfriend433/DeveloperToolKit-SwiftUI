//
//  RegexPattern.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import Foundation

struct RegexPattern: Identifiable {
    let id = UUID()
    let name: String
    let pattern: String
    let description: String
    let testString: String
    let examples: [String]
}
