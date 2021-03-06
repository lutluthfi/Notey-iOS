//
//  AppDIContainer+WorkspaceRepository.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation

extension AppDIContainer {
    
    func makeWorkspaceRepository() -> WorkspaceRepository {
        return DefaultWorkspaceRepository(localWorkspaceStorage: self.localWorkspaceStorage)
    }
    
}
