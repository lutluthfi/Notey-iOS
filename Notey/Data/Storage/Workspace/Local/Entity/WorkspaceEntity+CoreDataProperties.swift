//
//  WorkspaceEntity+CoreDataProperties.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//
//

import Foundation
import CoreData

extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var name: String
    @NSManaged public var updatedAt: Int64

}

extension WorkspaceEntity: Identifiable {

}
