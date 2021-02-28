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

// MARK: WorkspaceViewModelResponse
enum WorkspaceViewModelResponse {
}

// MARK: WorkspaceViewModelDelegate
protocol WorkspaceViewModelDelegate: class {
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
    func showWSDetailUI()

}

// MARK: WorkspaceViewModelOutput
protocol WorkspaceViewModelOutput {

    var response: Observable<WorkspaceViewModelResponse?> { get }

}

// MARK: WorkspaceViewModel
protocol WorkspaceViewModel: WorkspaceViewModelInput, WorkspaceViewModelOutput { }

// MARK: DefaultWorkspaceViewModel
final class DefaultWorkspaceViewModel: WorkspaceViewModel {

    // MARK: DI Variable
    weak var delegate: WorkspaceViewModelDelegate?
    let requestValue: WorkspaceViewModelRequestValue
    let route: WorkspaceViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    let response = Observable<WorkspaceViewModelResponse?>(nil)
    

    // MARK: Init Function
    init(
        requestValue: WorkspaceViewModelRequestValue,
        route: WorkspaceViewModelRoute
    ) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultWorkspaceViewModel {
    
    func viewDidLoad() {
    }
    
    func showWSDetailUI() {
        DispatchQueue.main.async { [weak self] in
            let instructor = WorkspaceFlowCoordinatorInstructor.detail
            self?.route.startWorkspaceUI(instructor)
        }
    }
    
}
