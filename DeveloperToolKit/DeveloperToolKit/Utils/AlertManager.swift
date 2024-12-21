//
//  AlertManager.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: String
}

extension AlertItem {
    static func error(_ error: Error) -> AlertItem {
        AlertItem(
            title: "Error",
            message: error.localizedDescription,
            dismissButton: "OK"
        )
    }
}
