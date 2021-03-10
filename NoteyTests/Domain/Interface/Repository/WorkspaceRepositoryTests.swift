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
    
    private lazy var sut: WorkspaceRepositorySUT = {
        return self.makeWorkspaceRepositorySUT()
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
        self.sut.localWorkspaceStorage
            .insertSynchronizeWorkspace(WorkspaceDomain.stubElement)
            .subscribe(onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }
    
    func removeStub() {
        self.sut.localWorkspaceStorage
            .removeAllWorkspace()
            .subscribe(onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }

}

extension WorkspaceRepositoryTests {
    
    func test_insertWorkspace_shouldInsertedIntoCoreData() {
        let given = WorkspaceDomain.stubElement
        
        let result = try? self.sut.workspaceRepository
            .insertWorkspace(given)
            .toBlocking(timeout: self.sut.insertElementTimeout)
            .single()
        
        XCTAssertNotNil(result)
        XCTAssertNotNil(result?.coreId)
    }
    
    func test_fetchAllWorkspace_shouldFetchedFromCoreData() {
        let result = (try? self.sut.workspaceRepository
                        .fetchAllWorkspace()
                        .toBlocking(timeout: self.sut.fetchCollectionTimeout)
                        .single()) ?? []
        
        XCTAssertTrue(!result.isEmpty)
    }
    
    func test_removeAllWorkspace_shouldRemovedFromCoreData() {
        let result = (try? self.sut.workspaceRepository
                        .removeAllWorkspace()
                        .toBlocking(timeout: self.sut.removeCollectionTimeout)
                        .single()) ?? []
        
        XCTAssertTrue(!result.isEmpty)
    }
    
}
