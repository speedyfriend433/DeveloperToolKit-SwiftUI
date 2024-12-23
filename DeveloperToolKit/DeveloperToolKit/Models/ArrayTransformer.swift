//
//  ArrayTransformer.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import Foundation

@objc(ArrayTransformer)
class ArrayTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self]
    }
    
    static func register() {
        let transformer = ArrayTransformer()
        ValueTransformer.setValueTransformer(
            transformer,
            forName: NSValueTransformerName("ArrayTransformer")
        )
    }
}
