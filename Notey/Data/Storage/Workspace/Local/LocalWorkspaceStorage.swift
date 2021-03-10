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
    func insertSynchronizeWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain>
    
    @discardableResult
    func removeAllWorkspace() -> Observable<[WorkspaceDomain]>
    
    @discardableResult
    func removeWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain>
    
}

public final class DefaultLocalWorkspaceStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultLocalWorkspaceStorage: LocalWorkspaceStorage {
    
    public func fetchAllWorkspace() -> Observable<[WorkspaceDomain]> {
        return Observable<[WorkspaceDomain]>.create { (observer) -> Disposable in
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
        }.observeOn(MainScheduler.instance)
    }
    
    public func insertSynchronizeWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain> {
        return Observable<WorkspaceDomain>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                do {
                    let request: NSFetchRequest = WorkspaceEntity.fetchRequest()
                    let exisitingEntities = try context.fetch(request)
                    let inserted: WorkspaceEntity
                    if let coreId = object.coreId,
                       let existing = exisitingEntities.first(where: { $0.objectID == coreId }) {
                        inserted = existing.synchronizeWithObjectId(with: object, context: context)
                    } else {
                        inserted = WorkspaceEntity(object, insertInto: context)
                    }
                    try context.save()
                    let domain = inserted.toDomain()
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
                    let entities = try context.fetch(request)
                    entities.forEach { context.delete($0) }
                    try context.save()
                    let domains = entities.map { $0.toDomain() }
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
    
    public func removeWorkspace(_ object: WorkspaceDomain) -> Observable<WorkspaceDomain> {
        return Observable<WorkspaceDomain>.create { [unowned self] (observer) -> Disposable in
            self.coreDataStorage.performBackgroundTask { (context) in
                guard let coreId = object.coreId else {
                    let message = "Failed to execute removeWorkspace(_:) caused by coreId is not available"
                    let error = NSError(domain: message, code: 0, userInfo: nil)
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }
                
                let removedObject = context.object(with: coreId)
                guard let entity = removedObject as? WorkspaceEntity else {
                    let message = "Failed to execute removeWorkspace(_:) caused by removedObject (\(removedObject)) is not WorkspaceEntity"
                    let error = NSError(domain: message, code: 0, userInfo: nil)
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }
                
                do {
                    context.delete(entity)
                    try context.save()
                    observer.onNext(object)
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
