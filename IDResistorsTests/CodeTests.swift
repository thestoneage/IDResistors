//
//  CodeTests.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import XCTest
@testable import IDResistors

extension Code: Equatable {
    public static func == (lhs: Code, rhs: Code) -> Bool {
        return lhs.value == rhs.value
    }
}

final class CodeTests: XCTestCase {

    func testColorCode() {
        let code = Code()
        let colorCode = ColorCode(digits: [.black, .black], multiplier: .black, tolerance: .gold)
        XCTAssertEqual(code?.colorCode(significantDigits: 2), colorCode)
    }

    func testColorCode1() {
        let code = Code(value: 560, tolerance: .brown)!
        let colorCode = ColorCode(digits: [.green, .blue, .black], multiplier: .black, tolerance: .brown)
        XCTAssertEqual(code.colorCode(significantDigits: 3), colorCode)
    }

    func testColorCode2() {
        let code = Code(value: 22_000, tolerance: .gold)!
        let colorCode = ColorCode(digits: [.red, .red,], multiplier: .orange, tolerance: .gold)
        XCTAssertEqual(code.colorCode(significantDigits: 2), colorCode)
    }

    func testColorCode3() {
        let code = Code(value: 470, tolerance: .gold)!
        let colorCode = ColorCode(digits: [.yellow, .violet], multiplier: .brown, tolerance: .gold)
        XCTAssertEqual(code.colorCode(significantDigits: 2), colorCode)
    }

    func testColorCode4() {
        let code = Code(value: 68, tolerance: .gold)!
        let colorCode = ColorCode(digits: [.blue, .gray], multiplier: .black, tolerance: .gold)
        XCTAssertEqual(code.colorCode(significantDigits: 2), colorCode)
    }

    func testColorCode5() {
        let code = Code(value: 4.7, tolerance: .gold)!
        let colorCode = ColorCode(digits: [.yellow, .violet, .black], multiplier: .silver, tolerance: .gold)
        XCTAssertEqual(code.colorCode(significantDigits: 3), colorCode)
    }


    func testSMDCode() {
        let code = Code()!
        let smdCode = "000"
        XCTAssertEqual(code.smdCode(digits: 3), smdCode)
    }

    func testSMDCode1() {
        let code = Code(value: 560)!
        let smdCode = "561"
        XCTAssertEqual(code.smdCode(digits: 3), smdCode)
    }

    func testSMDCode3() {
        let code = Code(value: 22_000)!
        let smdCode = "223"
        XCTAssertEqual(code.smdCode(digits: 3), smdCode)
    }

    func testScaledOhms1() {
        let code = Code(value: 22_000)!
        let measurement = Measurement<UnitElectricResistance>(value: 22, unit: .kiloohms)
        XCTAssertEqual(code.scaledOhms, measurement)
    }

    func testScaledOhms2() {
        let code = Code(value: 220)!
        let measurement = Measurement<UnitElectricResistance>(value: 220, unit: .ohms)
        XCTAssertEqual(code.scaledOhms, measurement)
    }

}
