//
//  RequestMethod.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import Foundation

enum RequestMethod: String, CaseIterable, Identifiable, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var id: String { self.rawValue }
}
