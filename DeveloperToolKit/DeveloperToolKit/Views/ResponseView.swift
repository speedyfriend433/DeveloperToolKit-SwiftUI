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
            Text("Response")
                .font(.headline)
            
            Group {
                statusView
                responseTimeView
                headersView
                bodyView
            }
            .font(.system(.body, design: .monospaced))
        }
    }
    
    private var statusView: some View {
        HStack {
            Text("Status:")
            Text("\(response.statusCode)")
                .foregroundColor(statusColor)
        }
    }
    
    private var responseTimeView: some View {
        HStack {
            Text("Time:")
            Text(String(format: "%.2f s", response.responseTime))
        }
    }
    
    private var headersView: some View {
        VStack(alignment: .leading) {
            Text("Headers:")
            
            ForEach(Array(response.headers.keys.sorted()), id: \.self) { key in
                if let value = response.headers[key] {
                    Text("\(key): \(value)")
                        .padding(.leading)
                }
            }
        }
    }
    
    private var bodyView: some View {
        VStack(alignment: .leading) {
            Text("Body:")
            
            ScrollView {
                Text(formattedBody)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 300)
            .border(Color.gray, width: 1)
        }
    }

    private var statusColor: Color {
        switch response.statusCode {
        case 200...299:
            return .green
        case 300...399:
            return .blue
        case 400...499:
            return .orange
        case 500...599:
            return .red
        default:
            return .primary
        }
    }
    
    private var formattedBody: String {
        if let data = response.body.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        return response.body
    }
}
