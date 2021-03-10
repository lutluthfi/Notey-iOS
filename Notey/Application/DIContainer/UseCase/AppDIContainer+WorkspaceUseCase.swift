//
//  AppDIContainer+WorkspaceUseCase.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation

extension AppDIContainer {
    
    func makeFetchAllWorkspaceUseCase() -> FetchAllWorkspaceUseCase {
        return DefaultFetchAllWorkspaceUseCase(workspaceRepository: self.makeWorkspaceRepository())
    }
    
    func makeInsertWorkspaceUseCae() -> InsertWorkspaceUseCase {
        return DefaultInsertWorkspaceUseCase(workspaceRepository: self.makeWorkspaceRepository())
    }
    
    func makeRemoveWorkspaceUseCase() -> RemoveWorkspaceUseCase {
        return DefaultRemoveWorkspaceUseCase(workspaceRepository: self.makeWorkspaceRepository())
    }
    
}
