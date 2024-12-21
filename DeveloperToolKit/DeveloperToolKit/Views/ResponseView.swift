//
//  ResponseView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct ResponseView: View {
    let response: APIResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status: \(response.statusCode)")
                .font(.subheadline)
            
            Text("Response Time: \(String(format: "%.2f", response.responseTime))s")
                .font(.subheadline)
            
            Text("Headers:")
                .font(.subheadline)
            
            ForEach(Array(response.headers.keys), id: \.self) { key in
                Text("\(key): \(response.headers[key] ?? "")")
                    .font(.caption)
            }
            
            Text("Body:")
                .font(.subheadline)
            
            ScrollView {
                Text(response.body)
                    .font(.system(.body, design: .monospaced))
            }
            .frame(maxHeight: 200)
        }
    }
}
