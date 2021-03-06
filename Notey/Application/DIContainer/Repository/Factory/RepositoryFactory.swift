//
//  RepositoryFactory.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation

extension AppDIContainer: RepositoryFactory { }

public protocol RepositoryFactory {
    
    func makeWorkspaceRepository() -> WorkspaceRepository
    
}
