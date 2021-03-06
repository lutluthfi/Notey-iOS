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
    private lazy var workspaceRepositoryStub: WorkspaceRepository = {
        return DefaultWorkspaceRepository(localWorkspaceStorage: self.localWorkspaceStorageStub)
    }()
    private lazy var insertWorksaceUseCase: InsertWorkspaceUseCase = {
        return DefaultInsertWorkspaceUseCase(workspaceRepository: self.workspaceRepositoryStub)
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
        self.workspaceRepositoryStub
            .insertWorkspace(WorkspaceDomain.stubElement)
            .subscribe(onNext: { [unowned self] workspace in
                self.insertedWorkspaceStub = workspace
            }, onCompleted: { [unowned self] in
                self.semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        self.semaphore.wait()
    }
    
    func removeStub() {
        self.workspaceRepositoryStub
            .removeAllWorkspace()
            .subscribe(onCompleted: { [unowned self] in
                self.semaphore.signal()
            })
            .disposed(by: self.disposeBag)
        self.semaphore.wait()
    }

}

extension InsertWorkspaceUseCaseTests {
    
    func test_execute_shouldSuccess() {
        var given = self.insertedWorkspaceStub!
        given.name = "Workspace 12345"
        
        let requestValue = InsertWorkspaceUseCaseRequestValue(workspace: given)
        
        var result: WorkspaceDomain?
        do {
            result = try self.insertWorksaceUseCase
                .execute(requestValue: requestValue)
                .toBlocking(timeout: self.insertElementTimeout)
                .single()
        } catch {
            let message = "InsertWorkspaceUseCaseTests -> [FAIL] " +
                "test_execute() " +
                "with given \(given) " +
                "caused by \(error.localizedDescription)"
            XCTFail(message)
        }
        
        XCTAssertNotNil(result?.coreId)
        XCTAssertEqual(result?.coreId, given.coreId)
        XCTAssertEqual(result?.name, given.name)
    }
    
}
