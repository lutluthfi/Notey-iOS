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
        self.id = domain.coreId
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        self.name = domain.name
    }
    
}

extension WorkspaceEntity {
    
    func toDomain() -> WorkspaceDomain {
        return WorkspaceDomain(
            coreId: self.id,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            name: self.name
        )
    }
    
}
