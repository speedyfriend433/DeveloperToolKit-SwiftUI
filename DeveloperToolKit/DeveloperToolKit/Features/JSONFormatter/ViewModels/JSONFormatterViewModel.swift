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
    @Published var error: Error?
    
    func formatJSON() {
        do {
            formattedJSON = try JSONFormatter.format(inputJSON)
        } catch {
            self.error = error
        }
    }
    
    func minifyJSON() {
        do {
            formattedJSON = try JSONFormatter.minify(inputJSON)
        } catch {
            self.error = error
        }
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = formattedJSON
    }
}
