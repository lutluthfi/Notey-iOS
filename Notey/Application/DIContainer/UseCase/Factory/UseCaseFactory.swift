//
//  UseCaseFactory.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 06/03/21.
//

import Foundation

extension AppDIContainer: UseCaseFactory { }

public protocol UseCaseFactory {
    
    func makeInsertWorkspaceUseCae() -> InsertWorkspaceUseCase
    
}
