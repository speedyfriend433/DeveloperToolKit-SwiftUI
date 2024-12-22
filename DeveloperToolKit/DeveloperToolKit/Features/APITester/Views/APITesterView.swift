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
                VStack(spacing: 16) {
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
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .addKeyboardToolbar()
        }
    }
    
    private var methodSelector: some View {
        Picker("Method", selection: $viewModel.selectedMethod) {
            ForEach(RequestMethod.allCases) { method in
                Text(method.rawValue).tag(method)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var urlInput: some View {
        TextField("Enter URL", text: $viewModel.url)
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .url)
            .autocapitalization(.none)
            .autocorrectionDisabled()
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("Headers")
                .font(.headline)
            
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
            
            Button(action: {
                Task {
                    await viewModel.addHeader()
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Header")
                }
                .foregroundColor(.blue)
            }
        }
    }
    
    private var requestBodySection: some View {
        VStack(alignment: .leading) {
            Text("Request Body")
                .font(.headline)
            
            TextEditor(text: $viewModel.requestBody)
                .frame(height: 150)
                .focused($focusedField, equals: .requestBody)
                .border(Color.gray, width: 1)
                .font(.system(.body, design: .monospaced))
        }
    }
    
    private var sendButton: some View {
        Button("Send Request") {
            Task {
                await viewModel.sendRequest()
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    APITesterView()
}
