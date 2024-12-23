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
            .toolbar {
                // Navigation Bar Items
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.showTemplates = true
                        } label: {
                            Label("Load Template", systemImage: "doc.text")
                        }
                        
                        Button {
                            viewModel.clearAll()
                        } label: {
                            Label("Clear All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                // Keyboard Toolbar
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .sheet(isPresented: $viewModel.showTemplates) {
                TemplateLibraryView(viewModel: viewModel)
            }
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
        VStack(alignment: .leading, spacing: 12) {
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
                .foregroundColor(Theme.primary)
            }
        }
    }
    
    private var requestBodySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Request Body")
                .font(.headline)
            
            TextEditor(text: $viewModel.requestBody)
                .frame(height: 150)
                .focused($focusedField, equals: .requestBody)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.border, lineWidth: 1)
                )
        }
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
                .background(Theme.primary)
                .cornerRadius(12)
        }
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
