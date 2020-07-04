//
//  ComputationsTests.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import XCTest
@testable import IDResistors

class ComputationsTests: XCTestCase {

    func testRound() throws {
        XCTAssertEqual(12, Computations.round(12.3, significantDigits: 2))
        XCTAssertEqual(13, Computations.round(12.5, significantDigits: 2))
        XCTAssertEqual(125, Computations.round(12.5, significantDigits: 3))
        XCTAssertEqual(13, Computations.round(125, significantDigits: 2))
        XCTAssertEqual(85, Computations.round(85, significantDigits: 2))
    }

    func testMultiplier() throws {
        XCTAssertEqual(0, Computations.multiplier(120.0, significantDigits: 3))
        XCTAssertEqual(1, Computations.multiplier(120.0, significantDigits: 2))
        XCTAssertEqual(-1, Computations.multiplier(12.0, significantDigits: 3))

    }

    func testDigits() {
        XCTAssertEqual([1,2,3], Computations.digits(1233, significantDigits: 3))
        XCTAssertEqual([1,2,4], Computations.digits(1235, significantDigits: 3))
        XCTAssertEqual([1,2,0], Computations.digits(12, significantDigits: 3))
        XCTAssertEqual([8,5], Computations.digits(85, significantDigits: 2))
        XCTAssertEqual([8,5], Computations.digits(8.5, significantDigits: 2))
    }

    func testDigits47() {
        XCTAssertEqual([4,7,0], Computations.digits(4.7, significantDigits: 3))
    }

    func testMultiplier47() {
        XCTAssertEqual(-2, Computations.multiplier(4.7, significantDigits: 3))
    }

    func testRound47() {
        XCTAssertEqual(470, Computations.round(4.7, significantDigits: 3))
    }
}
