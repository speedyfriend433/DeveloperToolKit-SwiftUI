//
//  HTTPMethod.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

enum RequestMethod: String, CaseIterable, Identifiable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var id: String { self.rawValue }
}
