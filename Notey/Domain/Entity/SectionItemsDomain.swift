//
//  SectionItemsDomain.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import Foundation
import RxDataSources

public struct SectionItems<Item> {
    
    public let footer: String?
    public let header: String?
    public var items: [Item]
    
}

extension SectionItems: SectionModelType {
    
    public init(original: SectionItems, items: [Item]) {
        self = original
        self.items = items
    }
    
}
