//
//  AppDIContainer+WorkspaceUseCase.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation

extension AppDIContainer {
    
    func makeInsertWorkspaceUseCae() -> InsertWorkspaceUseCase {
        return DefaultInsertWorkspaceUseCase(workspaceRepository: self.makeWorkspaceRepository())
    }
    
}
