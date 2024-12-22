//
//  JSONFormatterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation
import UIKit

class JSONFormatterViewModel: ObservableObject {
    @Published var inputJSON: String = ""
    @Published var formattedJSON: String = ""
    @Published var alertItem: AlertItem?
    
    func formatJSON() {
        guard !inputJSON.isEmpty else {
            showAlert(title: "Error", message: "Please enter JSON to format")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.format(inputJSON)
        } catch {
            showAlert(title: "Error", message: "Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func minifyJSON() {
        guard !inputJSON.isEmpty else {
            showAlert(title: "Error", message: "Please enter JSON to minify")
            return
        }
        
        do {
            formattedJSON = try JSONFormatter.minify(inputJSON)
        } catch {
            showAlert(title: "Error", message: "Invalid JSON: \(error.localizedDescription)")
        }
    }
    
    func copyToClipboard() {
        guard !formattedJSON.isEmpty else {
            showAlert(title: "Error", message: "No formatted JSON to copy")
            return
        }
        
        UIPasteboard.general.string = formattedJSON
        showAlert(title: "Success", message: "JSON copied to clipboard")
    }
    
    func clearInput() {
        inputJSON = ""
        formattedJSON = ""
    }
    
    private func showAlert(title: String, message: String) {
        alertItem = AlertItem(
            title: title,
            message: message,
            dismissButton: "OK"
        )
    }
}
