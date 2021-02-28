//
//  WSDetailViewModel.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import Foundation

// MARK: WSDetailViewModelResponse
enum WSDetailViewModelResponse {
}

// MARK: WSDetailViewModelDelegate
protocol WSDetailViewModelDelegate: class {
}

// MARK: WSDetailViewModelRequestValue
struct WSDetailViewModelRequestValue {
}

// MARK: WSDetailViewModelRoute
struct WSDetailViewModelRoute {
    
    var startWorkspaceFlow: ((WorkspaceFlowCoordinatorInstructor) -> Void)

}

// MARK: WSDetailViewModelInput
protocol WSDetailViewModelInput {
    func viewDidLoad()
    func showWorkspaceUI()
}

// MARK: WSDetailViewModelOutput
protocol WSDetailViewModelOutput {

    var response: Observable<WSDetailViewModelResponse?> { get }

}

// MARK: WSDetailViewModel
protocol WSDetailViewModel: WSDetailViewModelInput, WSDetailViewModelOutput { }

// MARK: DefaultWSDetailViewModel
final class DefaultWSDetailViewModel: WSDetailViewModel {

    // MARK: DI Variable
    weak var delegate: WSDetailViewModelDelegate?
    let requestValue: WSDetailViewModelRequestValue
    let route: WSDetailViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    let response = Observable<WSDetailViewModelResponse?>(nil)
    

    // MARK: Init Function
    init(
        requestValue: WSDetailViewModelRequestValue,
        route: WSDetailViewModelRoute
    ) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultWSDetailViewModel {
    
    func viewDidLoad() {
    }
    
    func showWorkspaceUI() {
        self.route.startWorkspaceFlow(.workspace)
    }
    
}
