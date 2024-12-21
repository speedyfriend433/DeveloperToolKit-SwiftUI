//
//  ContentView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            APITesterView()
                .tabItem {
                    Label("API Tester", systemImage: "network")
                }
            
            JSONFormatterView()
                .tabItem {
                    Label("JSON", systemImage: "doc.text")
                }
            
            RegexTesterView()
                .tabItem {
                    Label("Regex", systemImage: "textformat")
                }
            
            SnippetManagerView()
                .tabItem {
                    Label("Snippets", systemImage: "text.alignleft") // Updated icon
                }
        }
    }
}

#Preview {
    ContentView()
}
