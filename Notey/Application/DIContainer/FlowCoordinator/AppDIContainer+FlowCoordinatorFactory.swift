//
//  AppDIContainer+FlowCoordinatorFactory.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//

import Foundation

extension AppDIContainer: FlowCoordinatorFactory {
    
    func makeWorkspaceFlowCoordinator() -> WorkspaceFlowCoordinator {
        return DefaultWorkspaceFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
}
