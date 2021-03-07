//
//  FetchAllWorkspaceUseCaseTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

@testable import Notey
import RxSwift
import RxTest
import XCTest

class FetchAllWorkspaceUseCaseTests: XCTestCase {
    
    private lazy var sut: FetchAllWorkspaceUseCaseSUT = {
        return self.makeFetchAllWorkspaceUseCaseSUT()
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
        self.sut.workspaceRepository
            .insertWorkspace(WorkspaceDomain.stubElement)
            .subscribe(onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }
    
    func removeStub() {
        self.sut.workspaceRepository
            .removeAllWorkspace()
            .subscribe(onCompleted: { [unowned self] in
                self.sut.semaphore.signal()
            })
            .disposed(by: self.sut.disposeBag)
        self.sut.semaphore.wait()
    }

}

extension FetchAllWorkspaceUseCaseTests {
    
    func test_execute_shouldFetchedAllWorkspaceFromCoreData() {
        let requestValue = FetchAllWorkspaceUseCaseRequestValue()
        let result = (try? self.sut.fetchAllWorkspaceUseCase
                        .execute(requestValue: requestValue)
                        .toBlocking(timeout: self.sut.fetchCollectionTimeout)
                        .single()
                        .workspaces) ?? []
        
        XCTAssertTrue(!result.isEmpty)
        XCTAssertNotNil(result.first?.coreId)
    }
    
}
