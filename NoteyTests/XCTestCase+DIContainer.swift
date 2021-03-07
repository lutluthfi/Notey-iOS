//
//  XCTestCase+DIContainer.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

@testable import Notey
import Foundation
import RxSwift
import XCTest

extension XCTestCase {
    
    func makeDisposeBag() -> DisposeBag {
        return DisposeBag()
    }
    func makeSempahore() -> DispatchSemaphore {
        return DispatchSemaphore(value: 0)
    }
    
    // MARK: Timeout
    func getFetchCollectionTimeout() -> TimeInterval {
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        return coreDataStorageMock.fetchCollectionTimeout
    }
    func getInsertElementTimeout() -> TimeInterval {
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        return coreDataStorageMock.insertElementTimeout
    }
    func getRemoveCollectionTimeout() -> TimeInterval {
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        return coreDataStorageMock.removeCollectionTimeout
    }
    
    // MARK: CoreData
    func makeCoreDataStorageMock() -> CoreDataStorageSharedMock {
        return CoreDataStorageMock()
    }
    
    // MARK: Storage
    typealias LocalWorkspaceStorageSUT = (fetchCollectionTimeout: TimeInterval,
                                          insertElementTimeout: TimeInterval,
                                          removeCollectionTimeout: TimeInterval,
                                          coreDataStorageMock: CoreDataStorageSharedMock,
                                          localWorkspaceStorage: LocalWorkspaceStorage)
    func makeLocalWorkspaceStorageSUT() -> LocalWorkspaceStorageSUT {
        let fetchCollectionTimeout = self.getFetchCollectionTimeout()
        let insertElementTimeout = self.getInsertElementTimeout()
        let removeCollectionTimeout = self.getRemoveCollectionTimeout()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localWorkspaceStorage = DefaultLocalWorkspaceStorage(coreDataStorage: coreDataStorageMock)
        return (fetchCollectionTimeout,
                insertElementTimeout,
                removeCollectionTimeout,
                coreDataStorageMock,
                localWorkspaceStorage)
    }
    
    // MARK: Repository
    typealias WorkspaceRepositorySUT = (disposeBag: DisposeBag,
                                        semaphore: DispatchSemaphore,
                                        fetchCollectionTimeout: TimeInterval,
                                        insertElementTimeout: TimeInterval,
                                        removeCollectionTimeout: TimeInterval,
                                        localWorkspaceStorage: LocalWorkspaceStorage,
                                        workspaceRepository: WorkspaceRepository)
    func makeWorkspaceRepositorySUT() -> WorkspaceRepositorySUT {
        let disposeBag = self.makeDisposeBag()
        let semaphore = self.makeSempahore()
        let fetchCollectionTimeout = self.getFetchCollectionTimeout()
        let insertElementTimeout = self.getInsertElementTimeout()
        let removeCollectionTimeout = self.getRemoveCollectionTimeout()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localWorkspaceStorage = DefaultLocalWorkspaceStorage(coreDataStorage: coreDataStorageMock)
        let workspaceRepository = DefaultWorkspaceRepository(localWorkspaceStorage: localWorkspaceStorage)
        return (disposeBag,
                semaphore,
                fetchCollectionTimeout,
                insertElementTimeout,
                removeCollectionTimeout,
                localWorkspaceStorage,
                workspaceRepository)
    }
    
    // MARK: UseCase
    typealias FetchAllWorkspaceUseCaseSUT = (disposeBag: DisposeBag,
                                             semaphore: DispatchSemaphore,
                                             fetchCollectionTimeout: TimeInterval,
                                             workspaceRepository: WorkspaceRepository,
                                             fetchAllWorkspaceUseCase: FetchAllWorkspaceUseCase)
    func makeFetchAllWorkspaceUseCaseSUT() -> FetchAllWorkspaceUseCaseSUT {
        let disposeBag = self.makeDisposeBag()
        let semaphore = self.makeSempahore()
        let fetchCollectionTimeout = self.getFetchCollectionTimeout()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localWorkspaceStorage = DefaultLocalWorkspaceStorage(coreDataStorage: coreDataStorageMock)
        let workspaceRepository = DefaultWorkspaceRepository(localWorkspaceStorage: localWorkspaceStorage)
        let fetchAllWorkspaceUseCase = DefaultFetchAllWorkspaceUseCase(workspaceRepository: workspaceRepository)
        return (disposeBag, semaphore, fetchCollectionTimeout, workspaceRepository, fetchAllWorkspaceUseCase)
    }
    
    typealias InsertWorkspaceUseCaseSUT = (disposeBag: DisposeBag,
                                           semaphore: DispatchSemaphore,
                                           insertElementTimeout: TimeInterval,
                                           workspaceRepository: WorkspaceRepository,
                                           insertWorkspaceUseCase: InsertWorkspaceUseCase)
    func makeInsertWorkspaceUseCaseSUT() -> InsertWorkspaceUseCaseSUT {
        let disposeBag = self.makeDisposeBag()
        let semaphore = self.makeSempahore()
        let insertElementTimeout = self.getInsertElementTimeout()
        let coreDataStorageMock = self.makeCoreDataStorageMock()
        let localWorkspaceStorage = DefaultLocalWorkspaceStorage(coreDataStorage: coreDataStorageMock)
        let workspaceRepository = DefaultWorkspaceRepository(localWorkspaceStorage: localWorkspaceStorage)
        let insertWorkspaceUseCase = DefaultInsertWorkspaceUseCase(workspaceRepository: workspaceRepository)
        return (disposeBag, semaphore, insertElementTimeout, workspaceRepository, insertWorkspaceUseCase)
    }
    
}

