//
//  ArrayEquatableTests.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

@testable import Notey
import XCTest

class ArrayEquatableTests: XCTestCase {

    func test_removeFirstIndexOf() {
        var given = ["Jakarta", "Bandung", "Yogyakarta", "Malang", "Surabaya", "Not City"]
        
        given.remove(firstIndexOf: "Not City")
        
        XCTAssertTrue(!given.contains("Not City"))
    }

}
