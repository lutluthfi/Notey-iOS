//
//  InsertWorkspaceUseCase.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation
import RxSwift

public struct InsertWorkspaceUseCaseRequestValue {
    
    public let workspace: WorkspaceDomain
    
}

public protocol InsertWorkspaceUseCase {
    
    func execute(requestValue: InsertWorkspaceUseCaseRequestValue) -> Observable<WorkspaceDomain>
    
}

public final class DefaultInsertWorkspaceUseCase {
    
    let workspaceRepository: WorkspaceRepository
    
    public init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
}

extension DefaultInsertWorkspaceUseCase: InsertWorkspaceUseCase {
    
    public func execute(requestValue: InsertWorkspaceUseCaseRequestValue) -> Observable<WorkspaceDomain> {
        return self.workspaceRepository.insertWorkspace(requestValue.workspace)
    }
    
}
