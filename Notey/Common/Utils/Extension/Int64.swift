//
//  Int64.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import Foundation

public extension Int64 {
    
    func toDate(inEpochSeconds: Bool = false) -> Date {
        let _self = inEpochSeconds ? self / 1000 : self
        let timeInterval = TimeInterval(_self)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
}
