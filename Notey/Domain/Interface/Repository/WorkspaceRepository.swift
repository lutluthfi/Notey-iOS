//
//  WorkspaceRepository.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation
import RxSwift

public protocol WorkspaceRepository {
    
    func fetchAllWorkspace() -> Observable<[WorkspaceDomain]>
    
    @discardableResult
    func insertWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain>
    
    @discardableResult
    func removeAllWorkspace() -> Observable<[WorkspaceDomain]>
    
    @discardableResult
    func removeWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain>
    
}
