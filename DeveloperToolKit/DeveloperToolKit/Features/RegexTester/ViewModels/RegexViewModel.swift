//
//  RegexViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

@MainActor
class RegexViewModel: ObservableObject {
    @Published var pattern: String = ""
    @Published var testString: String = ""
    @Published var options: RegexOptions = RegexOptions()
    @Published var matches: [String] = []
    @Published var alertItem: AlertItem?
    
    func performMatch() {
        guard !pattern.isEmpty else {
            alertItem = AlertItem(
                title: "Error",
                message: "Please enter a regex pattern",
                dismissButton: "OK"
            )
            return
        }
        
        do {
            let regex = try createRegex()
            matches = findMatches(with: regex)
        } catch {
            alertItem = AlertItem.error(error)
            matches = []
        }
    }
    
    private func createRegex() throws -> NSRegularExpression {
        var options: NSRegularExpression.Options = []
        
        if self.options.caseInsensitive {
            options.insert(.caseInsensitive)
        }
        if self.options.multiline {
            options.insert(.anchorsMatchLines)
        }
        if self.options.dotMatchesAll {
            options.insert(.dotMatchesLineSeparators)
        }
        
        return try NSRegularExpression(pattern: pattern, options: options)
    }
    
    private func findMatches(with regex: NSRegularExpression) -> [String] {
        let range = NSRange(testString.startIndex..., in: testString)
        let matches = regex.matches(in: testString, range: range)
        
        return matches.compactMap { match in
            guard let range = Range(match.range, in: testString) else { return nil }
            return String(testString[range])
        }
    }
}
