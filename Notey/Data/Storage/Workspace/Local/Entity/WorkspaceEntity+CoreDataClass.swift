//
//  WorkspaceEntity+CoreDataClass.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//
//

import Foundation
import CoreData

@objc(WorkspaceEntity)
public class WorkspaceEntity: NSManagedObject {
    
    public static let entityName = String(describing: WorkspaceEntity.self)

    public convenience init(_ domain: WorkspaceDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        self.name = domain.name
    }
    
}

extension WorkspaceEntity {
    
    @discardableResult
    func synchronizeWithObjectId(with newObject: WorkspaceDomain, context: NSManagedObjectContext) -> WorkspaceEntity {
        guard self.objectID == newObject.coreId else {
            return WorkspaceEntity(newObject, insertInto: context)
        }
        self.createdAt = newObject.createdAt
        self.updatedAt = newObject.updatedAt
        self.name = newObject.name
        return self
    }
    
}

extension WorkspaceEntity {
    
    func toDomain() -> WorkspaceDomain {
        return WorkspaceDomain(coreId: self.objectID,
                               createdAt: self.createdAt,
                               updatedAt: self.updatedAt,
                               name: self.name)
    }
    
}
