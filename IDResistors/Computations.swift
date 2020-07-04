//
//  Computations.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import Foundation

struct Computations {

    static func round(_ num: Double, significantDigits: Int) -> Double {
        let p = log10(num)
        let rounded = p.rounded(.down)
        let sub = rounded - Double(significantDigits) + 1
        let f = pow(10, sub)
        let div = (num/f)
        let rdiv = div.rounded()
        return rdiv
    }

    static func multiplier(_ num: Double, significantDigits: Int) -> Int {
        let log = Int(log10(num).rounded(.down))
        let multiplier = log - significantDigits + 1
        return multiplier
    }

    static func value(digits: [Int], multiplier: Int) -> Double {
        let multi = pow(10.0, Double(multiplier))
        let sigDigs = digits.reversed()
            .enumerated()
            .map { (offset, digit) in
                pow(10.0, Double(offset)) * Double(digit)
        }.reduce(0.0, +)
        return multi * sigDigs
    }

    static func digits(_ value: Double, significantDigits: Int) -> [Int] {
        let rounded = Self.round(value, significantDigits: significantDigits)
        let digitsSlice =  String(rounded)
            .compactMap{ $0.wholeNumberValue }.prefix(significantDigits)
        return Array(digitsSlice)
    }
}
