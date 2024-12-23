//
//  CodeSnippetEntity+CoreDataProperties.swift
//  DeveloperToolKit
//
//  Created by speedy on 2024/12/23.
//
//

import Foundation
import CoreData


extension CodeSnippetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CodeSnippetEntity> {
        return NSFetchRequest<CodeSnippetEntity>(entityName: "CodeSnippetEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var language: String?
    @NSManaged public var tags: NSObject?
    @NSManaged public var title: String?

}

extension CodeSnippetEntity : Identifiable {

}
