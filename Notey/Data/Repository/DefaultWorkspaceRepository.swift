//
//  DefaultWorkspaceRepository.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation
import RxSwift

public final class DefaultWorkspaceRepository {
    
    let localWorkspaceStorage: LocalWorkspaceStorage
    
    public init(localWorkspaceStorage: LocalWorkspaceStorage) {
        self.localWorkspaceStorage = localWorkspaceStorage
    }
    
}

extension DefaultWorkspaceRepository: WorkspaceRepository {
    
    public func fetchAllWorkspace() -> Observable<[WorkspaceDomain]> {
        return self.localWorkspaceStorage.fetchAllWorkspace()
    }
    
    public func insertWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain> {
        return self.localWorkspaceStorage.insertWorkspace(object)
    }
    
    public func removeAllWorkspace() -> Observable<[WorkspaceDomain]> {
        return self.localWorkspaceStorage.removeAllWorkspace()
    }
    
}
