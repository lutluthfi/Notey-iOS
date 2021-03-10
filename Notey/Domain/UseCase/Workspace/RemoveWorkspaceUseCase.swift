//
//  RemoveWorkspaceUseCase.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import Foundation
import RxSwift

public struct RemoveWorkspaceUseCaseResponseValue {
    
    public let workspace: WorkspaceDomain
    
}

public struct RemoveWorkspaceUseCaseRequestValue {
    
    public let workspace: WorkspaceDomain
    
}

public protocol RemoveWorkspaceUseCase {
    
    func execute(requestValue: RemoveWorkspaceUseCaseRequestValue) -> Observable<RemoveWorkspaceUseCaseResponseValue>
    
}

public final class DefaultRemoveWorkspaceUseCase {
    
    let workspaceRepository: WorkspaceRepository
    
    public init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }
    
}

extension DefaultRemoveWorkspaceUseCase: RemoveWorkspaceUseCase {
    
    public func execute(
        requestValue: RemoveWorkspaceUseCaseRequestValue
    ) -> Observable<RemoveWorkspaceUseCaseResponseValue> {
        self.workspaceRepository
            .removeWorkspace(requestValue.workspace)
            .map { RemoveWorkspaceUseCaseResponseValue(workspace: $0) }
            .observeOn(MainScheduler.instance)
    }
    
}
