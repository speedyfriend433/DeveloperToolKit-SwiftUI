//
//  APITesterView.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

struct APITesterView: View {
    @StateObject private var viewModel = APITesterViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case url, requestBody
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    methodSelector
                    urlInput
                    headerSection
                    requestBodySection
                    
                    if let response = viewModel.response {
                        ResponseView(response: response)
                    }
                    
                    sendButton
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("API Tester")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text(alertItem.dismissButton))
                )
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .addKeyboardToolbar()
        }
    }
    
    private var methodSelector: some View {
        HStack(spacing: 0) {
            ForEach(RequestMethod.allCases) { method in
                MethodButton(
                    method: method,
                    isSelected: viewModel.selectedMethod == method,
                    action: { viewModel.selectedMethod = method }
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.border)
        )
        .padding(.vertical, 8)
    }
    
    private var urlInput: some View {
        TextField("Enter URL", text: $viewModel.url)
            .textFieldStyle(ModernTextFieldStyle())
            .focused($focusedField, equals: .url)
            .autocapitalization(.none)
            .autocorrectionDisabled()
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Headers")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            VStack(spacing: 8) {
                ForEach(viewModel.headers.indices, id: \.self) { index in
                    HeaderRowView(
                        header: $viewModel.headers[index],
                        onDelete: {
                            Task {
                                await viewModel.removeHeader(at: index)
                            }
                        }
                    )
                }
            }
            
            Button(action: {
                Task {
                    await viewModel.addHeader()
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Header")
                }
                .foregroundColor(Theme.primary)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var requestBodySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Request Body")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            TextEditor(text: $viewModel.requestBody)
                .frame(height: 150)
                .focused($focusedField, equals: .requestBody)
                .font(.system(.body, design: .monospaced))
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.border, lineWidth: 1)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var sendButton: some View {
        Button {
            Task {
                await viewModel.sendRequest()
            }
        } label: {
            Text("Send Request")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.primary)
                        .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 2)
                )
        }
        .padding(.vertical)
    }
}

struct MethodButton: View {
    let method: RequestMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(method.rawValue)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Theme.primary : Color.clear)
                .foregroundColor(isSelected ? .white : Theme.text)
                .cornerRadius(8)
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    APITesterView()
}
