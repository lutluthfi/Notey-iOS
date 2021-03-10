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
    
    var insertedWorkspaces: [WorkspaceDomain] = []
    
    override func setUp() {
        super.setUp()
        self.makeStub()
    }
    
    override func tearDown() {
        self.removeStub()
        super.tearDown()
    }
    
    private func makeStub() {
        let workspace = WorkspaceDomain.stubCollection
        let insertedEntities = workspace.map {
            WorkspaceEntity($0, insertInto: self.sut.coreDataStorageMock.context)
        }
        try! self.sut.coreDataStorageMock.context.save()
        self.insertedWorkspaces = insertedEntities.map { $0.toDomain() }
    }
    
    private func removeStub() {
        let context = self.sut.coreDataStorageMock.context
        let request: NSFetchRequest = WorkspaceEntity.fetchRequest()
        let workspaces = try! context.fetch(request)
        workspaces.forEach { context.delete($0) }
        try! context.save()
    }
    
}

extension LocalWorkspaceStorageTests {
    
    func test_insertSynchronizeWorkspace_whenWorkspaceNotStoredBefore_shouldInsertedIntoCoreData() {
        let name = "My Workspace"
        
        var given = WorkspaceDomain.stubElement
        given.name = "My Workspace"
        
        let result = try? self.sut.localWorkspaceStorage
            .insertSynchronizeWorkspace(given)
            .toBlocking(timeout: self.sut.insertElementTimeout)
            .single()
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.coreId)
        XCTAssertEqual(given.name, name)
    }
    
    func test_insertSynchronizeWorkspace_whenWorkspaceHasStoredBefore_shouldInsertedThenSynchronizedIntoCoreData() {
        let name = "Workspace for synchronized"
        
        var given = self.insertedWorkspaces[0]
        given.name = name
        
        let result = try? self.sut.localWorkspaceStorage
            .insertSynchronizeWorkspace(given)
            .toBlocking(timeout: self.sut.insertElementTimeout)
            .single()
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.coreId)
        XCTAssertEqual(given.name, name)
    }
    
    func test_fetchAllWorkspace_shouldFetchedFromCoreData() {
        let result = (try? self.sut.localWorkspaceStorage
                        .fetchAllWorkspace()
                        .toBlocking(timeout: self.sut.fetchCollectionTimeout)
                        .single()) ?? []
        
        XCTAssertTrue(!result.isEmpty)
    }
    
    func test_removeAllWorkspace_shouldRemovedFromCoreData() {
        let result = (try? self.sut.localWorkspaceStorage
                        .removeAllWorkspace()
                        .toBlocking(timeout: self.sut.removeCollectionTimeout)
                        .single()) ?? []
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result.count, self.insertedWorkspaces.count)
    }
    
    func test_removeWorkspace_shouldRemovedFromCoreData() {
        let given = self.insertedWorkspaces[0]
        
        let result = try? self.sut.localWorkspaceStorage
            .removeWorkspace(given)
            .toBlocking(timeout: self.sut.removeCollectionTimeout)
            .single()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.coreId, given.coreId)
    }
    
}
