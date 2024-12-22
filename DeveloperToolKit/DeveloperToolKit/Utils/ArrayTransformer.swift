//
//  ArrayTransformer.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/22.
//

import Foundation

@objc(StringArrayTransformer)
class StringArrayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: true)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [String]
    }
}
