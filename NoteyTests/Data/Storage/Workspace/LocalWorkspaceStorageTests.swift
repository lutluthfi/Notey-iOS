//
//  LocalWorkspaceStorageTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

@testable import Notey
import CoreData
import RxBlocking
import RxSwift
import RxTest
import XCTest

class LocalWorkspaceStorageTests: XCTestCase {
    
    private lazy var sut: LocalWorkspaceStorageSUT = {
        return self.makeLocalWorkspaceStorageSUT()
    }()
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        do {
            let workspace = WorkspaceDomain.stubCollection
            _ = workspace.map { WorkspaceEntity($0, insertInto: self.sut.coreDataStorageMock.context) }
            try self.sut.coreDataStorageMock.context.save()
        } catch {
            XCTFail("LocalWorkspaceStorageTests -> [FAIL] makeStub() caused by \(error.localizedDescription)")
        }
    }
    
    private func removeStub() {
        do {
            let context = self.sut.coreDataStorageMock.context
            let request: NSFetchRequest = WorkspaceEntity.fetchRequest()
            let workspaces = try context.fetch(request)
            workspaces.forEach { (entity) in
                context.delete(entity)
            }
            try context.save()
        } catch  {
            XCTFail("LocalWorkspaceStorageTests -> [FAIL] flushStub() caused by \(error.localizedDescription)")
        }
    }
    
}

private extension LocalWorkspaceStorageTests {
    
    func test_insertSynchronizeWorkspace_shouldInsertedIntoCoreData() {
        let given = WorkspaceDomain.stubElement
        
        var result: WorkspaceDomain?
        do {
            result = try self.sut.localWorkspaceStorage
                .insertSynchronizeWorkspace(given)
                .toBlocking(timeout: self.sut.insertElementTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_insertSynchronizeWorkspace_shouldInsertedIntoCoreData() " +
                "with given \(given) " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertNotNil(result?.coreId)
    }
    
    func test_fetchAllWorkspace_shouldFetchedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.sut.localWorkspaceStorage
                .fetchAllWorkspace()
                .toBlocking(timeout: self.sut.fetchCollectionTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_fetchAllWorkspace_shouldFetchedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
    func test_removeAllWorkspace_shouldRemovedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.sut.localWorkspaceStorage
                .removeAllWorkspace()
                .toBlocking(timeout: self.sut.removeCollectionTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_removeAllWorkspace_shouldRemovedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
}
