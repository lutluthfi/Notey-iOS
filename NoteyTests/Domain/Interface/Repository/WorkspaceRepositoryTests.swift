//
//  WorkspaceRepositoryTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

@testable import Notey
import RxSwift
import RxTest
import XCTest

class WorkspaceRepositoryTests: XCTestCase {

    private let disposeBag = DisposeBag()
    private let semaphore = DispatchSemaphore(value: 0)
    private var fetchCollectionTimeout: TimeInterval {
        return self.coreDataStorageMock.fetchCollectionTimeout
    }
    private var insertElementTimeout: TimeInterval {
        return self.coreDataStorageMock.insertElementTimeout
    }
    private var removeCollectionTimeout: TimeInterval {
        return self.coreDataStorageMock.removeCollectionTimeout
    }
    private lazy var coreDataStorageMock: CoreDataStorageSharedMock = CoreDataStorageMock()
    private lazy var localWorkspaceStorageStub: LocalWorkspaceStorage = {
        return DefaultLocalWorkspaceStorage(coreDataStorage: self.coreDataStorageMock)
    }()
    private lazy var workspaceRepository: WorkspaceRepository = {
        return DefaultWorkspaceRepository(localWorkspaceStorage: self.localWorkspaceStorageStub)
    }()
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    func makeStub() {
        self.localWorkspaceStorageStub
            .insertSynchronizeWorkspace(WorkspaceDomain.stubElement)
            .subscribe(onCompleted: { [unowned self] in
                self.semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        self.semaphore.wait()
    }
    
    func removeStub() {
        self.localWorkspaceStorageStub
            .removeAllWorkspace()
            .subscribe(onCompleted: { [unowned self] in
                self.semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        self.semaphore.wait()
    }

}

extension WorkspaceRepositoryTests {
    
    func test_insertWorkspace_shouldInsertedToCoreData() {
        let given = WorkspaceDomain.stubElement
        
        var result: WorkspaceDomain?
        do {
            result = try self.workspaceRepository
                .insertWorkspace(given)
                .toBlocking(timeout: self.insertElementTimeout)
                .single()
        } catch {
            let message = "WorkspaceRepositoryTests -> [FAIL] " +
                "test_insertWorkspace_thenInsertedToCoreData() " +
                "with given \(given) " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertNotNil(result)
    }
    
    func test_fetchAllWorkspace_shouldFetchedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.workspaceRepository
                .fetchAllWorkspace()
                .toBlocking(timeout: self.fetchCollectionTimeout)
                .single()
        } catch {
            let message = "WorkspaceRepositoryTests -> [FAIL] " +
                "test_fetchAllWorkspace_thenFetchedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
    func test_removeAllWorkspace_shouldRemovedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.workspaceRepository
                .removeAllWorkspace()
                .toBlocking(timeout: self.removeCollectionTimeout)
                .single()
        } catch {
            let message = "WorkspaceRepositoryTests -> [FAIL] " +
                "test_removeAllWorkspace_thenRemovedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
}
