//
//  Date.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import Foundation

public extension Date {
    
    func toInt64(inEpochSeconds: Bool = false) -> Int64 {
        let timeInterval = self.timeIntervalSince1970
        return inEpochSeconds ? Int64(timeInterval) * 1000 : Int64(timeInterval)
    }
    
}
