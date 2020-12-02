//
//  Code.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import Foundation

enum DigitRing: Int, CaseIterable, Identifiable, Equatable {
    var id: Self { self }

    case black = 0
    case brown = 1
    case red = 2
    case orange = 3
    case yellow = 4
    case green = 5
    case blue = 6
    case violet = 7
    case gray = 8
    case white = 9
}

enum MultiplierRing: Int, CaseIterable, Identifiable, Equatable {
    var id: Self { self }

    case black = 0
    case brown = 1
    case red = 2
    case orange = 3
    case yellow = 4
    case green = 5
    case blue = 6
    case violet = 7
    case gray = 8
    case white = 9
    case gold = -1
    case silver = -2
}

enum ToleranceRing: Double, CaseIterable, Identifiable, Equatable, Codable {
    var id: Self { self }

    case brown = 0.01
    case red = 0.02
    case orange = 0.03
    case yellow = 0.04
    case green = 0.005
    case blue = 0.0025
    case violet = 0.0001
    case gray = 0.0005
    case silver = 0.1
    case gold = 0.05

    var string: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .percent
        fmt.maximumFractionDigits = 3
        let nsnumber = NSNumber(value: self.rawValue)
        return "± \(fmt.string(from: nsnumber)!)"
    }
}

struct ColorCode: Equatable {
    var digits: [DigitRing]
    var multiplier: MultiplierRing
    var tolerance: ToleranceRing
}

struct CodePreset: Codable {
    var id = UUID()
    var value: Measurement<UnitElectricResistance>
    var tolerance: ToleranceRing = .gold
}

extension CodePreset {
    static let key = "CodeCoreKey"

    static let initialPresets: [CodePreset] = [
        100,
        220,
        470,
        330,
        680,
        1_000,
        1_500,
        2_200,
        3_300,
        4_700,
        6_800,
        10_000,
        15_000,
        22_000,
        33_000,
        47_000,
        68_000,
        100_000,
        220_000,
        470_000,
    ].map {
        CodePreset(value: Measurement.init(value: $0, unit: UnitElectricResistance.ohms))
    }
}

class Code: ObservableObject {
    static let userDictValueKey = "VALUE"

    @Published var value: Double
    @Published var toleranceRing: ToleranceRing = .gold

    init?(value: Double = 0.0, tolerance: ToleranceRing = .gold) {
        guard value >= 0 else { return nil }
        self.value = value
        self.toleranceRing = tolerance
    }

    var preset: CodePreset {
        get {
            return CodePreset(value: ohms, tolerance: toleranceRing)
        }
        set {
            self.value = newValue.value.converted(to: UnitElectricResistance.ohms).value
            self.toleranceRing = newValue.tolerance
        }
    }

    var ohms:Measurement<UnitElectricResistance> {
        return Measurement.init(value: value, unit: UnitElectricResistance.ohms)
    }

    var scaledOhms: Measurement<UnitElectricResistance> {
        switch value {
        case 1_000..<1_000_000:
            return Measurement.init(value: value, unit: UnitElectricResistance.ohms).converted(to: UnitElectricResistance.kiloohms)
        case 1_000_000..<Double.infinity:
            return Measurement.init(value: value, unit: UnitElectricResistance.ohms).converted(to: UnitElectricResistance.megaohms)
        default:
            return Measurement.init(value: value, unit: UnitElectricResistance.ohms)
        }
    }
    
    static func colorCode(_ value: Double, significantDigits: Int, tolerance: ToleranceRing) -> ColorCode {
        guard value != 0.0 else {
            return ColorCode(digits: Array(repeating: .black, count: significantDigits),
                             multiplier: .black,
                             tolerance: tolerance)
        }
        let digits = Computations.digits(value, significantDigits: significantDigits)
        let multiplier = Computations.multiplier(value, significantDigits: significantDigits)
        return ColorCode(digits: digits.map { DigitRing(rawValue: $0) ?? DigitRing.black },
                         multiplier: MultiplierRing(rawValue: multiplier) ?? .black,
                         tolerance: tolerance)
    }

    func colorCode(significantDigits: Int) -> ColorCode {
        Self.colorCode(self.value, significantDigits: significantDigits, tolerance: toleranceRing)
    }

    func update(colorCode: ColorCode) {
        let digits = colorCode.digits.map(\.rawValue)
        let multiplier = colorCode.multiplier.rawValue
        self.toleranceRing = colorCode.tolerance
        self.value = Computations.value(digits: digits, multiplier: multiplier)
    }

    func smdCode(digits: Int) -> String {
        guard value != 0 else { return String(repeating: "0", count: digits) }
        if value < pow(10.0, Double(digits - 2)) {
            let f = NumberFormatter()
            f.decimalSeparator = "R"
            f.minimumFractionDigits = digits - 1
            f.maximumFractionDigits = digits + 1
            f.minimumIntegerDigits = 0
            f.alwaysShowsDecimalSeparator = true
            let number = NSNumber(value: self.value)
            let string = f.string(from: number)!
            return String(string.prefix(digits))
        }
        else {
            return String(Computations.round(self.value, significantDigits: digits - 1)).prefix(digits - 1)
                + String(Computations.multiplier(self.value, significantDigits: digits - 1))
        }
    }

    func update(smdCode: String) {
        if smdCode.contains("R") {
            if let parsedValue = Double(smdCode.replacingOccurrences(of: "R", with: ".")) {
                self.value = parsedValue
            }
        }
        else {
            if let l = smdCode.last, let m = Double(String(l)), let s = Double(smdCode.dropLast()) {
                self.value = s * pow(10.0, m)
            }
        }
    }
}
