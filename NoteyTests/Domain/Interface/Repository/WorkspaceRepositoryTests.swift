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

    let disposeBag = DisposeBag()
    let semaphore = DispatchSemaphore(value: 0)
    var fetchCollectionTimeout: TimeInterval {
        return self.coreDataStorageMock.fetchCollectionTimeout
    }
    var insertElementTimeout: TimeInterval {
        return self.coreDataStorageMock.insertElementTimeout
    }
    var removeCollectionTimeout: TimeInterval {
        return self.coreDataStorageMock.removeCollectionTimeout
    }
    
    lazy var coreDataStorageMock: CoreDataStorageSharedMock = CoreDataStorageMock()
    lazy var localWorkspaceStorageStub: LocalWorkspaceStorage = {
        return DefaultLocalWorkspaceStorage(coreDataStorage: self.coreDataStorageMock)
    }()
    lazy var workspaceRepositoryStub: WorkspaceRepository = {
        return DefaultWorkspaceRepository(localWorkspaceStorage: self.localWorkspaceStorageStub)
    }()
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.flushStub()
        super.tearDown()
    }
    
    func makeStub() {
        self.localWorkspaceStorageStub
            .insertWorkspace(WorkspaceDomain.stubElement)
            .subscribe(onCompleted: { [unowned self] in
                self.semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        self.semaphore.wait()
    }
    
    func flushStub() {
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
    
    func test_insertWorkspace_thenInsertedToCoreData() {
        let given = WorkspaceDomain(coreId: "1",
                                    createdAt: Date().toInt64(),
                                    updatedAt: Date().toInt64(),
                                    name: "1")
        
        var result: [WorkspaceDomain] = []
        do {
            result = try self.workspaceRepositoryStub
                .insertWorkspace(given)
                .toBlocking(timeout: self.insertElementTimeout)
                .toArray()
        } catch {
            let message = "WorkspaceRepositoryTests -> [FAIL] " +
                "test_insertWorkspace_thenInsertedToCoreData() " +
                "with given \(given) " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        let expectation = [
            WorkspaceDomain(coreId: "1",
                            createdAt: Date().toInt64(),
                            updatedAt: Date().toInt64(),
                            name: "1")
        ]
        
        XCTAssertEqual(result, expectation)
    }
    
    func test_fetchAllWorkspace_thenFetchedFromCoreData() {
        var result: [WorkspaceDomain] = []
        do {
            result = try self.workspaceRepositoryStub
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
    
    func test_removeAllWorkspace_thenRemovedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.workspaceRepositoryStub
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
