//
//  WorkspaceDomain.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import CoreData
import Foundation

public struct WorkspaceDomain {
 
    public let coreId: CoreID?
    public var createdAt: Int64
    public var updatedAt: Int64
    
    public var name: String
    
    public init(coreId: CoreID? = nil, createdAt: Int64, updatedAt: Int64, name: String) {
        self.coreId = coreId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.name = name
    }
    
}

extension WorkspaceDomain: Equatable {
    
    public static func == (lhs: WorkspaceDomain, rhs: WorkspaceDomain) -> Bool {
        return lhs.coreId == rhs.coreId
    }
    
}
