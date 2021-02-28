//
//  AppDIContainer.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//

import UIKit

typealias PresentationFactory = FlowCoordinatorFactory & ViewControllerFactory
typealias ViewControllerFactory = WorkspaceFlowCoordinatorFactory

final class AppDIContainer {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
