//
//  InsertWorkspaceUseCaseTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

@testable import Notey
import RxSwift
import RxTest
import XCTest

class InsertWorkspaceUseCaseTests: XCTestCase {
    
    private lazy var sut: InsertWorkspaceUseCaseSUT = {
        return self.makeInsertWorkspaceUseCaseSUT()
    }()
    private var insertedWorkspaceStub: WorkspaceDomain?
    
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
            .subscribe(onNext: { [unowned self] workspace in
                self.insertedWorkspaceStub = workspace
            }, onCompleted: { [unowned self] in
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

extension InsertWorkspaceUseCaseTests {
    
    func test_execute_shouldInsertedWorkspaceIntoCoreData() {
        var given = self.insertedWorkspaceStub!
        given.name = "Workspace 12345"
        
        let requestValue = InsertWorkspaceUseCaseRequestValue(workspace: given)
        
        let result = try? self.sut.insertWorkspaceUseCase
            .execute(requestValue: requestValue)
            .toBlocking(timeout: self.sut.insertElementTimeout)
            .single()
        
        XCTAssertNotNil(result?.coreId)
        XCTAssertEqual(result?.coreId, given.coreId)
        XCTAssertEqual(result?.name, given.name)
    }
    
}
