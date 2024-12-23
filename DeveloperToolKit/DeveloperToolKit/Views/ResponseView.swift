//
//  ResponseView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct ResponseView: View {
    let response: APIResponse
    @State private var copiedText: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                statusView
                Spacer()
                responseTimeView
            }

            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(title: "Headers", action: copyHeaders)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(response.headers.keys.sorted()), id: \.self) { key in
                            if let value = response.headers[key] {
                                Text("\(key): \(value)")
                                    .font(.system(.caption, design: .monospaced))
                            }
                        }
                    }
                    .padding(8)
                }
                .frame(maxHeight: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(title: "Body", action: copyBody)
                
                ScrollView([.horizontal, .vertical]) {
                    Text(formattedBody)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding(8)
                }
                .frame(maxHeight: 300)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            Button(action: copyAll) {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy Complete Response")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2))
        )
        .overlay(
            copiedOverlay
        )
    }
    
    struct SectionHeader: View {
        let title: String
        let action: () -> Void

        var body: some View {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                Button(action: action) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy")
                    }
                    .font(.caption)
                    .foregroundColor(Theme.primary)
                }
            }
        }
    }
    
    private var statusView: some View {
        HStack {
            Text("Status:")
                .fontWeight(.medium)
            Text("\(response.statusCode)")
                .foregroundColor(statusColor)
                .fontWeight(.bold)
        }
    }
    
    private var responseTimeView: some View {
        Text(String(format: "%.2f s", response.responseTime))
            .font(.caption)
            .foregroundColor(.gray)
    }
    
    private var statusColor: Color {
        switch response.statusCode {
        case 200...299: return .green
        case 300...399: return .blue
        case 400...499: return .orange
        case 500...599: return .red
        default: return .gray
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
    
    private var copiedOverlay: some View {
        Group {
            if let text = copiedText {
                VStack {
                    Text("\(text) copied!")
                        .font(.caption)
                        .padding(8)
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .transition(.scale.combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            copiedText = nil
                        }
                    }
                }
            }
        }
    }
    
    private func copyHeaders() {
        let headerString = response.headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
        UIPasteboard.general.string = headerString
        withAnimation {
            copiedText = "Headers"
        }
    }
    
    private func copyBody() {
        UIPasteboard.general.string = formattedBody
        withAnimation {
            copiedText = "Body"
        }
    }
    
    private func copyAll() {
        let allContent = """
        Status: \(response.statusCode)
        Time: \(String(format: "%.2f s", response.responseTime))
        
        Headers:
        \(response.headers.map { "\($0.key): \($0.value)" }.joined(separator: "\n"))
        
        Body:
        \(formattedBody)
        """
        UIPasteboard.general.string = allContent
        withAnimation {
            copiedText = "Complete response"
        }
    }
}


