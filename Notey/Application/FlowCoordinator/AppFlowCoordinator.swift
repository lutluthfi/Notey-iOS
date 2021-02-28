//
//  AppFlowCoordinator.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//

import UIKit

protocol AppFlowCoordinator {
    func start(with instructor: AppFlowCoordinatorInstructor)
}

enum AppFlowCoordinatorInstructor {
    case `default`
}

final class DefaultAppFlowCoordinator {
    
    let navigationController: UINavigationController
    let flowFactory: FlowCoordinatorFactory
    
    init(navigationController: UINavigationController, presentationFactory: PresentationFactory) {
        self.navigationController = navigationController
        self.flowFactory = presentationFactory
    }
    
    
}

extension DefaultAppFlowCoordinator: AppFlowCoordinator {
    
    func start(with instructor: AppFlowCoordinatorInstructor) {
        self.flowFactory.makeWorkspaceFlowCoordinator().start(with: .workspace)
    }
    
}
