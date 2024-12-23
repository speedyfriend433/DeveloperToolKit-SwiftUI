//
//  CodeSnippetEntity+CoreDataProperties.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//

import Foundation
import CoreData

extension CodeSnippetEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CodeSnippetEntity> {
        return NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var code: String?
    @NSManaged public var language: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var tagsData: Data?
    
    var tags: [String] {
        get {
            if let data = tagsData,
               let array = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [String] {
                return array
            }
            return []
        }
        set {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue as NSArray, requiringSecureCoding: true) {
                tagsData = data
            }
        }
    }
}
