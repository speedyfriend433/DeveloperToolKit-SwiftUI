//
//  JSONFormatterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI
import Combine

@MainActor
class JSONFormatterViewModel: ObservableObject {
    @Published var inputJSON: String = ""
    @Published var formattedJSON: String = ""
    @Published var alertItem: AlertItem?
    @Published var options: JSONFormatterOptions = JSONFormatterOptions()
    
    func formatJSON() async {
        guard !inputJSON.isEmpty else {
            showError("Please enter JSON to format")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.format(inputJSON, options: options)
        } catch {
            showError("Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func minifyJSON() async {
        guard !inputJSON.isEmpty else {
            showError("Please enter JSON to minify")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.minify(inputJSON)
        } catch {
            showError("Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func copyToClipboard() async {
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
    
    func clearAll() async {
        inputJSON = ""
        formattedJSON = ""
        options = JSONFormatterOptions()
    }
    
    private func showError(_ message: String) {
        alertItem = AlertItem(
            title: "Error",
            message: message,
            dismissButton: "OK"
        )
    }
}
