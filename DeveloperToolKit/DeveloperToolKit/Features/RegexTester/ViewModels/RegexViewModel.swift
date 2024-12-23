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
    @Published var options = RegexOptions()
    @Published var matches: [String] = []
    @Published var alertItem: AlertItem?
    @Published var showSamples = false
    
    func performMatch() async {
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
                
                if matches.isEmpty {
                    alertItem = AlertItem(
                        title: "No Matches",
                        message: "No matches found for the current pattern",
                        dismissButton: "OK"
                    )
                }
            } catch {
                alertItem = AlertItem(
                    title: "Error",
                    message: error.localizedDescription,
                    dismissButton: "OK"
                )
                matches = []
            }
        }
    
    private func createRegex() throws -> NSRegularExpression {
        var regexOptions: NSRegularExpression.Options = []
        
        if options.caseInsensitive {
            regexOptions.insert(.caseInsensitive)
        }
        if options.multiline {
            regexOptions.insert(.anchorsMatchLines)
        }
        if options.dotMatchesAll {
            regexOptions.insert(.dotMatchesLineSeparators)
        }
        
        return try NSRegularExpression(pattern: pattern, options: regexOptions)
    }
    
    private func findMatches(with regex: NSRegularExpression) -> [String] {
        let range = NSRange(testString.startIndex..., in: testString)
        let matches = regex.matches(in: testString, range: range)
        
        return matches.compactMap { match in
            guard let range = Range(match.range, in: testString) else { return nil }
            return String(testString[range])
        }
    }
    
    func clearAll() {
        pattern = ""
        testString = ""
        matches = []
    }
}
