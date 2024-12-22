//
//  APITesterViewModel.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

@MainActor
class APITesterViewModel: ObservableObject {
    @Published var selectedMethod: RequestMethod = .get // Changed from HTTPMethod to RequestMethod
    @Published var url: String = ""
    @Published var headers: [Header] = []
    @Published var requestBody: String = ""
    @Published var response: APIResponse?
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
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
}
