//
//  JSONFormatterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

@MainActor
class JSONFormatterViewModel: ObservableObject {
    @Published var inputJSON: String = ""
    @Published var formattedJSON: String = ""
    @Published var alertItem: AlertItem?
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    @Published var options: JSONFormatterOptions = JSONFormatterOptions()
    
    func formatJSON() {
        guard !inputJSON.isEmpty else {
            showError("Please enter JSON to format")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.format(inputJSON, options: options)
            hasError = false
            errorMessage = ""
        } catch {
            showError("Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func minifyJSON() {
        guard !inputJSON.isEmpty else {
            showError("Please enter JSON to minify")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.minify(inputJSON)
            hasError = false
            errorMessage = ""
        } catch {
            showError("Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func copyToClipboard() {
        guard !formattedJSON.isEmpty else {
            showError("No formatted JSON to copy")
            return
        }
        
        UIPasteboard.general.string = formattedJSON
        alertItem = AlertItem(
            title: "Success",
            message: "JSON copied to clipboard",
            dismissButton: "OK"
        )
    }
    
    func clearInput() {
        inputJSON = ""
        formattedJSON = ""
        hasError = false
        errorMessage = ""
    }
    
    func clearAll() {
        clearInput()
        options = JSONFormatterOptions()
    }
    
    func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            inputJSON = string
        }
    }
    
    private func showError(_ message: String) {
        hasError = true
        errorMessage = message
        alertItem = AlertItem(
            title: "Error",
            message: message,
            dismissButton: "OK"
        )
    }
}
