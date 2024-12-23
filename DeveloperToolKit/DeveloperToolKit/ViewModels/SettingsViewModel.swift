//
//  SettingsViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = AppTheme.system.rawValue
    @Published var selectedTheme: AppTheme
    
    init() {

        selectedTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.system.rawValue) ?? .system
        
        _selectedThemeRaw = AppStorage(wrappedValue: selectedTheme.rawValue, "selectedTheme")
    }
    
    func updateTheme(_ newTheme: AppTheme) {
        selectedTheme = newTheme
        selectedThemeRaw = newTheme.rawValue
    }
}
