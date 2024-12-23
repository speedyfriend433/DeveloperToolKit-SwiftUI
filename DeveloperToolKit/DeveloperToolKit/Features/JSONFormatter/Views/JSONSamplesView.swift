//
//  JSONSamplesView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct JSONSamplesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JSONFormatterViewModel
    
    let samples: [(name: String, json: String)] = [
        (
            "Simple Object",
            """
            {
                "name": "John Doe",
                "age": 30,
                "email": "john@example.com",
                "isActive": true
            }
            """
        ),
        (
            "Array of Objects",
            """
            {
                "users": [
                    {
                        "id": 1,
                        "name": "John Doe",
                        "email": "john@example.com"
                    },
                    {
                        "id": 2,
                        "name": "Jane Smith",
                        "email": "jane@example.com"
                    }
                ]
            }
            """
        ),
        (
            "Nested Objects",
            """
            {
                "company": {
                    "name": "Tech Corp",
                    "location": {
                        "city": "San Francisco",
                        "country": "USA"
                    },
                    "employees": 500
                }
            }
            """
        ),
        (
            "Complex Structure",
            """
            {
                "id": "12345",
                "timestamp": "2024-01-01T12:00:00Z",
                "user": {
                    "id": 1,
                    "name": "John Doe",
                    "contacts": {
                        "email": "john@example.com",
                        "phone": "+1-234-567-8900"
                    }
                },
                "orders": [
                    {
                        "id": "ORD-1",
                        "items": [
                            {
                                "id": "ITEM-1",
                                "name": "Product A",
                                "quantity": 2,
                                "price": 29.99
                            },
                            {
                                "id": "ITEM-2",
                                "name": "Product B",
                                "quantity": 1,
                                "price": 49.99
                            }
                        ],
                        "total": 109.97
                    }
                ],
                "settings": {
                    "notifications": true,
                    "theme": "dark",
                    "language": "en-US"
                }
            }
            """
        ),
        (
            "API Response",
            """
            {
                "status": "success",
                "code": 200,
                "data": {
                    "users": [
                        {
                            "id": 1,
                            "name": "John Doe",
                            "role": "admin",
                            "permissions": ["read", "write", "delete"]
                        }
                    ],
                    "metadata": {
                        "total": 1,
                        "page": 1,
                        "perPage": 10
                    }
                }
            }
            """
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(samples, id: \.name) { sample in
                        SampleCard(
                            name: sample.name,
                            json: sample.json,
                            onSelect: {
                                viewModel.inputJSON = sample.json
                                dismiss()
                            }
                        )
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Sample JSON")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SampleCard: View {
    let name: String
    let json: String
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Spacer()
                
                Text("\(jsonLength) characters")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Preview
            Text(json.prefix(200) + (json.count > 200 ? "..." : ""))
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(Theme.text.opacity(0.8))
                .lineLimit(5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Action Buttons
            HStack {
                // Copy Button
                Button {
                    UIPasteboard.general.string = json
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .tint(Theme.primary)
                
                Spacer()
                
                // Use Button
                Button(action: onSelect) {
                    Label("Use This", systemImage: "arrow.right.circle.fill")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.primary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var jsonLength: Int {
        json.count
    }
}

#Preview {
    JSONSamplesView(viewModel: JSONFormatterViewModel())
}
