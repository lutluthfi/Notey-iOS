//
//  FlowCoordinatorFactory.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 27/02/21.
//

import Foundation

protocol FlowCoordinatorFactory {
    func makeWorkspaceFlowCoordinator() -> WorkspaceFlowCoordinator
}
