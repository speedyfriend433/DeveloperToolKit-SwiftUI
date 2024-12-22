//
//  APITesterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import SwiftUI

@MainActor
class APITesterViewModel: ObservableObject {
    @Published var selectedMethod: RequestMethod = .get
    @Published var url: String = ""
    @Published var headers: [Header] = []
    @Published var requestBody: String = ""
    @Published var response: APIResponse?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    @Published var showTemplates = false
    
    private let networkService = NetworkService()
    
    func addHeader() async {
        headers.append(Header(key: "", value: ""))
    }
    
    func removeHeader(at index: Int) async {
        headers.remove(at: index)
    }
    
    func sendRequest() async {
        guard let url = URL(string: url) else {
            alertItem = AlertItem(
                title: "Invalid URL",
                message: "Please enter a valid URL",
                dismissButton: "OK"
            )
            return
        }
        
        isLoading = true
        
        do {
            response = try await NetworkService.makeRequest(
                url: url,
                method: selectedMethod,
                headers: headers,
                body: requestBody
            )
        } catch {
            alertItem = AlertItem(
                title: "Error",
                message: error.localizedDescription,
                dismissButton: "OK"
            )
        }
        
        isLoading = false
    }
    
    func loadTemplate(_ template: RequestTemplate) {
        // Convert template request to view model state
        url = template.request.url
        selectedMethod = RequestMethod(rawValue: template.request.method) ?? .get
        headers = template.request.headers.map { dict in
            Header(key: dict["key"] ?? "", value: dict["value"] ?? "")
        }
        requestBody = template.request.body
    }
    
    func saveAsTemplate(name: String, description: String, category: String) {
        // Convert view model state to template request
        let template = RequestTemplate(
            id: UUID(),
            name: name,
            description: description,
            category: category,
            request: RequestTemplate.TemplateRequest(
                url: url,
                method: selectedMethod.rawValue,
                headers: headers.map { ["key": $0.key, "value": $0.value] },
                body: requestBody
            )
        )
        
        // Here you would typically save the template to persistent storage
        print("Template saved:", template)
    }
}
