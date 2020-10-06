//
//  Task+CoreDataProperties.swift
//  Taskee
//
//  Created by Mark Kim on 9/22/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var status: Bool
    @NSManaged public var due: Date?
    @NSManaged public var title: String?
    @NSManaged public var projectrelation: NSObject?
    @NSManaged public var project: Project?

}

extension Task : Identifiable {

}
