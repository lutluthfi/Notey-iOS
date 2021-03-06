//
//  LocalWorkspaceStorageTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

@testable import Notey
import CoreData
import RxBlocking
import RxSwift
import RxTest
import XCTest

class LocalWorkspaceStorageTests: XCTestCase {

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
    private lazy var localStorage: LocalWorkspaceStorage = {
        return DefaultLocalWorkspaceStorage(coreDataStorage: self.coreDataStorageMock)
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
            _ = workspace.map { WorkspaceEntity($0, insertInto: self.coreDataStorageMock.context) }
            try self.coreDataStorageMock.context.save()
        } catch {
            XCTFail("LocalWorkspaceStorageTests -> [FAIL] makeStub() caused by \(error.localizedDescription)")
        }
    }
    
    private func removeStub() {
        do {
            let context = self.coreDataStorageMock.context
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
    
    func test_insertWorkspace_shouldInsertedToCoreData() {
        let given = WorkspaceDomain.stubElement
        
        var result: WorkspaceDomain?
        do {
            result = try self.localStorage
                .insertWorkspace(given)
                .toBlocking(timeout: self.insertElementTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_insertWorkspace_thenInsertedToCoreData() " +
                "with given \(given) " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertNotNil(result?.coreId)
    }
    
    func test_fetchAllWorkspace_shouldFetchedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.localStorage
                .fetchAllWorkspace()
                .toBlocking(timeout: self.fetchCollectionTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_fetchAllWorkspace_thenFetchedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
    func test_removeAllWorkspace_shouldRemovedFromCoreData() {
        var result: [WorkspaceDomain] = []
        
        do {
            result = try self.localStorage
                .removeAllWorkspace()
                .toBlocking(timeout: self.removeCollectionTimeout)
                .single()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
                "test_removeAllWorkspace_thenRemovedFromCoreData() " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertTrue(!result.isEmpty)
    }
    
}
