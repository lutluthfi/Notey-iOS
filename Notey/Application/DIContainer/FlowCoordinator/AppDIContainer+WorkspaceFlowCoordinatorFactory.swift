//
//  AppDIContainer+WorkspaceFlowCoordinatorFactory.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//

import UIKit

extension AppDIContainer: WorkspaceFlowCoordinatorFactory { }


extension AppDIContainer {
    
    func makeWSDetailController(requestValue: WSDetailViewModelRequestValue,
                                route: WSDetailViewModelRoute) -> UIViewController {
        let viewModel = self.makeWSDetailViewModel(requestValue: requestValue, route: route)
        return WSDetailController.create(with: viewModel)
    }
    
    private func makeWSDetailViewModel(requestValue: WSDetailViewModelRequestValue,
                                       route: WSDetailViewModelRoute) -> WSDetailViewModel {
        return DefaultWSDetailViewModel(requestValue: requestValue, route: route)
    }
    
}

extension AppDIContainer {
    
    func makeWorkspaceController(requestValue: WorkspaceViewModelRequestValue,
                                 route: WorkspaceViewModelRoute) -> UIViewController {
        let viewModel = self.makeWorkspaceViewModel(requestValue: requestValue, route: route)
        return WorkspaceController.create(with: viewModel)
    }
    
    private func makeWorkspaceViewModel(requestValue: WorkspaceViewModelRequestValue,
                                        route: WorkspaceViewModelRoute) -> WorkspaceViewModel {
        return DefaultWorkspaceViewModel(requestValue: requestValue, route: route)
    }
    
}
