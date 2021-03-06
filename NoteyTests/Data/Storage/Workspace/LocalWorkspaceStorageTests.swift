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
    lazy var localStorage: LocalWorkspaceStorage = DefaultLocalWorkspaceStorage(coreDataStorage: self.coreDataStorageMock)
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.flushStub()
        super.tearDown()
    }
    
    func flushStub() {
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
    
    func makeStub() {
        do {
            let workspace = WorkspaceDomain.stubCollection
            _ = workspace.map { WorkspaceEntity($0, insertInto: self.coreDataStorageMock.context) }
            try self.coreDataStorageMock.context.save()
        } catch {
            XCTFail("LocalWorkspaceStorageTests -> [FAIL] makeStub() caused by \(error.localizedDescription)")
        }
    }
    
}

extension LocalWorkspaceStorageTests {
    
    func test_insertWorkspace_thenInsertedToCoreData() {
        let given = WorkspaceDomain(coreId: "1",
                                    createdAt: Date().toInt64(),
                                    updatedAt: Date().toInt64(),
                                    name: "1")
        
        var result: [WorkspaceDomain] = []
        do {
            result = try self.localStorage
                .insertWorkspace(given)
                .toBlocking(timeout: self.insertElementTimeout)
                .toArray()
        } catch {
            let message = "LocalWorkspaceStorageTests -> [FAIL] " +
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
    
    func test_removeAllWorkspace_thenRemovedFromCoreData() {
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
