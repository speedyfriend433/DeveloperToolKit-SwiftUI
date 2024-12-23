//
//  SettingsView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
            List {

                Section {
                    ThemePicker(selection: $viewModel.selectedTheme)
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Choose how the app appears")
                }
                
                Section(header: Text("General")) {
                    Toggle("Show Line Numbers", isOn: .constant(true))
                    
                    HStack {
                        Text("Default Language")
                        Spacer()
                        Text("Swift")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Editor Font")
                        Spacer()
                        Text("SF Mono")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Features")) {
                    Toggle("Syntax Highlighting", isOn: .constant(true))
                    Toggle("Auto Completion", isOn: .constant(true))
                    Toggle("Auto Save", isOn: .constant(true))
                }
                
                Section(header: Text("Support")) {
                    Link(destination: URL(string: "https://example.com/help")!) {
                        HStack {
                            Text("Help & Documentation")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                    
                    Link(destination: URL(string: "mailto:speedyfriend433@gmail.com")!) {
                        HStack {
                            Text("Contact Support")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                    
                    Link(destination: URL(string: "https://example.com/terms")!) {
                        HStack {
                            Text("Terms of Use")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ThemePicker: View {
    @Binding var selection: AppTheme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(AppTheme.allCases, id: \.self) { theme in
                HStack {
                    Image(systemName: theme.icon)
                        .foregroundColor(theme == .light ? .orange :
                                       theme == .dark ? .indigo : .gray)
                    Text(theme.rawValue)
                }
                .tag(theme)
            }
        }
    }
}

#Preview {
    SettingsView()
}
