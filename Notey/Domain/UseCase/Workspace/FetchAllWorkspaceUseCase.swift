//
//  FetchAllWorkspaceUseCase.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public struct FetchAllWorkspaceUseCaseResponseValue {
    
    public let workspaces: [WorkspaceDomain]
    
}

public struct FetchAllWorkspaceUseCaseRequestValue {

}

public protocol FetchAllWorkspaceUseCase {
    
    func execute(
        requestValue: FetchAllWorkspaceUseCaseRequestValue
    ) -> Observable<FetchAllWorkspaceUseCaseResponseValue>

}

public final class DefaultFetchAllWorkspaceUseCase {

    let workspaceRepository: WorkspaceRepository
    
    public init(workspaceRepository: WorkspaceRepository) {
        self.workspaceRepository = workspaceRepository
    }

}

extension DefaultFetchAllWorkspaceUseCase: FetchAllWorkspaceUseCase {

    public func execute(
        requestValue: FetchAllWorkspaceUseCaseRequestValue
    ) -> Observable<FetchAllWorkspaceUseCaseResponseValue> {
        return self.workspaceRepository
            .fetchAllWorkspace()
            .map { FetchAllWorkspaceUseCaseResponseValue(workspaces: $0) }
    }
    
}
