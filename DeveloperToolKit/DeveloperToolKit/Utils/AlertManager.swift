//
//  AlertManager.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

extension AlertItem {
    static func error(_ error: Error) -> AlertItem {
        AlertItem(
            title: "Error",
            message: error.localizedDescription,
            dismissButton: "OK"
        )
    }
}
