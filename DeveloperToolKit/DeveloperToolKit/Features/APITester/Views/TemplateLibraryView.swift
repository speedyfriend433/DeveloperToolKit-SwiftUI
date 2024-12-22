//
//  TemplateLibraryView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import SwiftUI

struct TemplateLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: APITesterViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(templatesForCategory(category)) { template in
                            TemplateRowView(template: template) {
                                viewModel.loadTemplate(template)
                                dismiss()
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Templates")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var categories: [String] {
        Array(Set(RequestTemplate.samples.map(\.category))).sorted()
    }
    
    private func templatesForCategory(_ category: String) -> [RequestTemplate] {
        RequestTemplate.samples.filter { $0.category == category }
    }
}

struct TemplateRowView: View {
    let template: RequestTemplate
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(template.name)
                    .font(.headline)
                
                Spacer()
                
                Text(template.request.method)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(methodColor.opacity(0.1))
                    .foregroundColor(methodColor)
                    .cornerRadius(8)
            }
            
            Text(template.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(template.request.url)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
    
    private var methodColor: Color {
        switch template.request.method {
        case "GET": return .blue
        case "POST": return .green
        case "PUT": return .orange
        case "DELETE": return .red
        default: return .gray
        }
    }
}

#Preview {
    TemplateLibraryView(viewModel: APITesterViewModel())
}
