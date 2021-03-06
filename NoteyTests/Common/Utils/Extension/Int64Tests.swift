//
//  Int64Tests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import XCTest
@testable import Notey

class Int64Test: XCTestCase {
    
    func test_toDate_whenEpochSeconds_thenResultSuccess() {
        let given = Int64(1614511408000)
        let expectation = Date(timeIntervalSince1970: 1614511408)
        
        let givenDate = given.toDate(inEpochSeconds: true)
        
        XCTAssertTrue(givenDate == expectation)
    }
    
    func test_toDate_whenNotEpochSeconds_thenResultSuccess() {
        let given = Int64(1614511408)
        let expectation = Date(timeIntervalSince1970: 1614511408)
        
        let givenDate = given.toDate()
        
        XCTAssertTrue(givenDate == expectation)
    }
    
}
