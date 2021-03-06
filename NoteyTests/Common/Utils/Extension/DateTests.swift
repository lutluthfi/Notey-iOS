//
//  DateTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import XCTest
@testable import Notey

class DateTests: XCTestCase {
    
    func test_toInt64_whenEpochSeconds_thenResultSuccess() {
        let given = Date(timeIntervalSince1970: 1614511408)
        let expectation = Int64(1614511408000)
        
        let givenInt64 = given.toInt64(inEpochSeconds: true)
        
        XCTAssertTrue(givenInt64 == expectation)
    }
    
    func test_toInt64_whenNotEpochSeconds_thenResultSuccess() {
        let given = Date(timeIntervalSince1970: 1614511408)
        let expectation = Int64(1614511408)
        
        let givenInt64 = given.toInt64()
        
        XCTAssertTrue(givenInt64 == expectation)
    }
    
}
