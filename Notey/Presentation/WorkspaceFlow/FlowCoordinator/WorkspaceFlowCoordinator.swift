//
//  WorkspaceFlowCoordinator.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: WorkspaceFlowCoordinatorFactory
protocol WorkspaceFlowCoordinatorFactory  {

    func makeWSDetailController(requestValue: WSDetailViewModelRequestValue,
                                route: WSDetailViewModelRoute) -> UIViewController
    
    func makeWorkspaceController(requestValue: WorkspaceViewModelRequestValue,
                                 route: WorkspaceViewModelRoute) -> UIViewController
    
}

// MARK: WorkspaceFlowCoordinator
protocol WorkspaceFlowCoordinator {
    func start(with instructor: WorkspaceFlowCoordinatorInstructor)
}

// MARK: WorkspaceFlowCoordinatorInstructor
enum WorkspaceFlowCoordinatorInstructor {
    case detail
    case workspace
}

// MARK: DefaultWorkspaceFlowCoordinator
final class DefaultWorkspaceFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: WorkspaceFlowCoordinatorFactory

    // MARK: Init Funciton
    init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
    }
    
}

extension DefaultWorkspaceFlowCoordinator: WorkspaceFlowCoordinator {
    
    func start(with instructor: WorkspaceFlowCoordinatorInstructor) {
        switch instructor {
        case .detail:
            let requestValue = WSDetailViewModelRequestValue()
            let scene = self.initDetailUI(requestValue: requestValue)
            self.navigationController.pushViewController(scene, animated: true)
        case .workspace:
            let requestValue = WorkspaceViewModelRequestValue()
            let scene = self.initWorkspaceUI(requestValue: requestValue)
            self.navigationController.pushViewController(scene, animated: true)
        }
    }
    
}

extension DefaultWorkspaceFlowCoordinator {
    
    func initDetailUI(requestValue: WSDetailViewModelRequestValue) -> UIViewController {
        let route = WSDetailViewModelRoute(startWorkspaceFlow: self.start(with:))
        return self.controllerFactory.makeWSDetailController(requestValue: requestValue, route: route)
    }
    
    func initWorkspaceUI(requestValue: WorkspaceViewModelRequestValue) -> UIViewController {
        let route = WorkspaceViewModelRoute(startWorkspaceUI: self.start(with:))
        return self.controllerFactory.makeWorkspaceController(requestValue: requestValue, route: route)
    }
    
}
