//
//  JSONFormatterOptions.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct JSONFormatterOptions: Equatable {
    // Indentation
    var indentationSpaces: Int = 2
    var useTabs: Bool = false
    
    // Formatting
    var sortKeys: Bool = false
    var maxLineLength: Int = 80
    var lineWrapping: Bool = true
    
    // Array Formatting
    var arrayItemsPerLine: Int = 1
    var arrayWrapping: ArrayWrappingStyle = .auto
    
    // String Formatting
    var escapeSlashes: Bool = true
    var escapeUnicode: Bool = false
    var quoteStyle: QuoteStyle = .double
    
    // Spacing
    var spaceAfterColon: Bool = true
    var spaceInsideBrackets: Bool = false
    var spaceInsideBraces: Bool = false
    var trailingCommas: Bool = false
    
    enum ArrayWrappingStyle: String, CaseIterable {
        case auto = "Auto"
        case all = "One Item Per Line"
        case none = "All In One Line"
    }
    
    enum QuoteStyle: String, CaseIterable {
        case single = "Single Quotes"
        case double = "Double Quotes"
    }
}
