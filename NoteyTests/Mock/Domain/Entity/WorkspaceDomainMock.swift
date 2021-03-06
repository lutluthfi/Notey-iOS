//
//  WorkspaceDomainTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

@testable import Notey
import Foundation
import RxSwift

extension WorkspaceDomain {
    
    static var stubCollection: [WorkspaceDomain] {
        let now = Date()
        return [
            WorkspaceDomain(createdAt: now.toInt64(),
                            updatedAt: now.toInt64(),
                            name: "Workspace for one"),
            WorkspaceDomain(createdAt: now.toInt64(),
                            updatedAt: now.toInt64(),
                            name: "Workspace for two"),
            WorkspaceDomain(createdAt: now.toInt64(),
                            updatedAt: now.toInt64(),
                            name: "Workspace for three"),
            WorkspaceDomain(createdAt: now.toInt64(),
                            updatedAt: now.toInt64(),
                            name: "Workspace for four"),
            WorkspaceDomain(createdAt: now.toInt64(),
                            updatedAt: now.toInt64(),
                            name: "Workspace for five")
        ]
    }
    
    static var stubCollectionObservable: Observable<[WorkspaceDomain]> {
        return Observable.create { (observer) -> Disposable in
            let workspaces = WorkspaceDomain.stubCollection
            observer.onNext(workspaces)
            return Disposables.create()
        }
    }
    
    static var stubElement: WorkspaceDomain {
        let now = Date()
        return WorkspaceDomain(createdAt: now.toInt64(),
                               updatedAt: now.toInt64(),
                               name: "Workspace for one")
    }
    
}
