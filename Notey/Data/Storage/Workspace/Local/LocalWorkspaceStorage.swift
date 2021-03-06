//
//  LocalWorkspaceStorage.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import CoreData
import Foundation
import RxSwift

public protocol LocalWorkspaceStorage: WorkspaceStorage {
    
    func fetchAllWorkspace() -> Observable<[WorkspaceDomain]>
    
    @discardableResult
    func insertWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain>
    
    @discardableResult
    func removeAllWorkspace() -> Observable<[WorkspaceDomain]>
    
}

public final class DefaultLocalWorkspaceStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultLocalWorkspaceStorage: LocalWorkspaceStorage {
    
    public func fetchAllWorkspace() -> Observable<[WorkspaceDomain]> {
        return Observable<[WorkspaceDomain]>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let request: NSFetchRequest = WorkspaceEntity.fetchRequest()
                    request.sortDescriptors = [
                        NSSortDescriptor(key: #keyPath(WorkspaceEntity.createdAt),  ascending: false)
                    ]
                    let result = try context.fetch(request).map { $0.toDomain() }
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    let error = CoreDataStorageError.readError(error)
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(CurrentThreadScheduler.instance)
    }
    
    public func insertWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain> {
        return Observable<WorkspaceDomain>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let entity = WorkspaceEntity(object, insertInto: context)
                    try context.save()
                    let domain = entity.toDomain()
                    observer.onNext(domain)
                    observer.onCompleted()
                } catch {
                    let error = CoreDataStorageError.saveError(error)
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(CurrentThreadScheduler.instance)
    }
    
    public func removeAllWorkspace() -> Observable<[WorkspaceDomain]> {
        return Observable<[WorkspaceDomain]>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let request: NSFetchRequest = WorkspaceEntity.fetchRequest()
                    let workspaces = try context.fetch(request)
                    workspaces.forEach { (element) in
                        context.delete(element)
                    }
                    try context.save()
                    let domains = workspaces.map { $0.toDomain() }
                    observer.onNext(domains)
                    observer.onCompleted()
                } catch {
                    let error = CoreDataStorageError.deleteError(error)
                    observer.onError(error)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }.observeOn(CurrentThreadScheduler.instance)
    }
    
}
