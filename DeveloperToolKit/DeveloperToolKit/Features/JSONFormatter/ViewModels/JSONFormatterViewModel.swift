//
//  JSONFormatterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

@MainActor
class JSONFormatterViewModel: ObservableObject {
    @Published var inputJSON = ""
    @Published var formattedJSON = ""
    @Published var options = JSONFormatterOptions()
    @Published var alertItem: AlertItem?
    
    func formatJSON() {
        guard !inputJSON.isEmpty else { return }
        
        do {
            formattedJSON = try JSONFormatter.format(inputJSON, options: options)
        } catch {
            alertItem = AlertItem(
                title: "Error",
                message: "Invalid JSON: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func minifyJSON() {
        guard !inputJSON.isEmpty else { return }
        
        do {
            formattedJSON = try JSONFormatter.minify(inputJSON)
        } catch {
            alertItem = AlertItem(
                title: "Error",
                message: "Invalid JSON: \(error.localizedDescription)",
                dismissButton: "OK"
            )
        }
    }
    
    func copyToClipboard() {
        guard !formattedJSON.isEmpty else { return }
        UIPasteboard.general.string = formattedJSON
    }
    
    func pasteFromClipboard() {
        guard let string = UIPasteboard.general.string else { return }
        inputJSON = string
    }
    
    func clearAll() {
        inputJSON = ""
        formattedJSON = ""
    }
}
