//
//  AlertItem.swift
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
