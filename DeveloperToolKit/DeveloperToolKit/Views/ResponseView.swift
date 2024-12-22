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
        VStack(alignment: .leading, spacing: 16) {
            Text("Response")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            VStack(alignment: .leading, spacing: 12) {
                statusView
                responseTimeView
                headersView
                bodyView
            }
            .font(.system(.body, design: .monospaced))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var statusView: some View {
            HStack {
                Text("Status:")
                    .foregroundColor(Theme.text)
                Text("\(response.statusCode)")
                    .foregroundColor(statusColor)
                    .fontWeight(.bold)
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

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(Theme.primary)
                
                Text("Sending Request...")
                    .font(.headline)
                    .foregroundColor(Theme.text)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
        }
    }
}
