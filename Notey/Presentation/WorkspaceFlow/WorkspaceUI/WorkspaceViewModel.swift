//
//  WorkspaceViewModel.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import Foundation
import RxSwift

// MARK: WorkspaceViewModelResponse
enum WorkspaceViewModelResponse {
}

// MARK: WorkspaceViewModelDelegate
protocol WorkspaceViewModelDelegate: AnyObject {
}

// MARK: WorkspaceViewModelRequestValue
struct WorkspaceViewModelRequestValue {
}

// MARK: WorkspaceViewModelRoute
struct WorkspaceViewModelRoute {
    var startWorkspaceUI: (WorkspaceFlowCoordinatorInstructor) -> Void
}

// MARK: WorkspaceViewModelInput
protocol WorkspaceViewModelInput {

    func viewDidLoad()
    
    func doCreateWorkspace(name: String)
    func doRemoveWorkspace(_ workspace: WorkspaceDomain)
    func showWSDetailUI()

}

// MARK: WorkspaceViewModelOutput
protocol WorkspaceViewModelOutput {

    var displayedWorkspaces: BehaviorSubject<[WorkspaceDomain]> { get }
    var fetchAllWorkspaceUseCaseFailure: PublishSubject<Error> { get }

}

// MARK: WorkspaceViewModel
protocol WorkspaceViewModel: AnyObject, WorkspaceViewModelInput, WorkspaceViewModelOutput { }

// MARK: DefaultWorkspaceViewModel
final class DefaultWorkspaceViewModel: WorkspaceViewModel {

    // MARK: DI Variable
    weak var delegate: WorkspaceViewModelDelegate?
    let requestValue: WorkspaceViewModelRequestValue
    let route: WorkspaceViewModelRoute

    // MARK: UseCase Variable
    let fetchAllWorkspaceUseCase: FetchAllWorkspaceUseCase
    let insertWorkspaceUseCase: InsertWorkspaceUseCase
    let removeWorkspaceUseCase: RemoveWorkspaceUseCase

    // MARK: Common Variable
    var _displayedWorkspaces: [WorkspaceDomain] = []
    

    // MARK: Output ViewModel
    let disposeBag = DisposeBag()
    let displayedWorkspaces = BehaviorSubject<[WorkspaceDomain]>(value: [])
    let fetchAllWorkspaceUseCaseFailure = PublishSubject<Error>()
    

    // MARK: Init Function
    init(
        requestValue: WorkspaceViewModelRequestValue,
        route: WorkspaceViewModelRoute,
        fetchAllWorkspaceUseCase: FetchAllWorkspaceUseCase,
        insertWorkspaceUseCase: InsertWorkspaceUseCase,
        removeWorkspaceUseCase: RemoveWorkspaceUseCase
    ) {
        self.requestValue = requestValue
        self.route = route
        self.fetchAllWorkspaceUseCase = fetchAllWorkspaceUseCase
        self.insertWorkspaceUseCase = insertWorkspaceUseCase
        self.removeWorkspaceUseCase = removeWorkspaceUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultWorkspaceViewModel {
    
    func viewDidLoad() {
        self.fetchAllWorkspaceUseCase
            .execute(requestValue: FetchAllWorkspaceUseCaseRequestValue())
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] responseValue in
                let workspaces = responseValue.workspaces
                self._displayedWorkspaces = workspaces
                self.displayedWorkspaces.onNext(workspaces)
            }, onError: { [unowned self] error in
                self.fetchAllWorkspaceUseCaseFailure.onNext(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func doCreateWorkspace(name: String) {
        let now = Date().toInt64()
        let newWorkspace = WorkspaceDomain(createdAt: now, updatedAt: now, name: name)
        self.insertWorkspaceUseCase
            .execute(requestValue: InsertWorkspaceUseCaseRequestValue(workspace: newWorkspace))
            .subscribe(onNext: { [unowned self] newWorkspace in
                self._displayedWorkspaces.insert(newWorkspace, at: 0)
                self.displayedWorkspaces.onNext(self._displayedWorkspaces)
            }, onError: { _ in
                
            })
            .disposed(by: self.disposeBag)
    }
    
    func doRemoveWorkspace(_ workspace: WorkspaceDomain) {
        self.removeWorkspaceUseCase
            .execute(requestValue: RemoveWorkspaceUseCaseRequestValue(workspace: workspace))
            .subscribe(onNext: { [unowned self] responseValue in
                let index = self._displayedWorkspaces.firstIndex(of: responseValue.workspace)!
                self._displayedWorkspaces.remove(at: index)
                self.displayedWorkspaces.onNext(self._displayedWorkspaces)
            }, onError: { _ in
                
            })
            .disposed(by: self.disposeBag)
    }
    
    func showWSDetailUI() {
        DispatchQueue.main.async { [weak self] in
            let instructor = WorkspaceFlowCoordinatorInstructor.detail
            self?.route.startWorkspaceUI(instructor)
        }
    }
    
}
