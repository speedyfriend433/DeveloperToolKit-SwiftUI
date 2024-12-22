//
//  RegexOptionsView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

// RegexOptionsView
struct RegexOptionsView: View {
    @Binding var options: RegexOptions
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Options")
                .font(.headline)
            
            VStack {
                Toggle("Case Insensitive", isOn: $options.caseInsensitive)
                Toggle("Multi-line", isOn: $options.multiline)
                Toggle("Dot Matches All", isOn: $options.dotMatchesAll)
            }
        }
    }
}
