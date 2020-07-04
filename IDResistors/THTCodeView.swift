//
//  THTCodeView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

public protocol ColorConvertable {
    var color: Color { get }
    var highlight: Color? { get }
}

enum Selection: Equatable {
    case none
    case multiplier
    case tolerance
    case digit(Int)
}

struct THTCodeView: View {
    
    @EnvironmentObject var code: Code
    @Environment(\.colorScheme) var colorScheme
    @Binding var significantDigits: Int
    @State var selection: Selection = .none

    func text(multiplier: MultiplierRing) -> Text {
        let value = pow(10.0, Double(multiplier.rawValue))
        let fmt = NumberFormatter()
        fmt.numberStyle = .scientific
        return Text(fmt.string(from: NSNumber(value:value))!)
    }

    func selectionView(colorCode: Binding<ColorCode>) -> some View {
        switch selection {
        case .none:
            return AnyView(EmptyView())
        case .multiplier:
            return AnyView(THTMultiplierSelectionView(selection: $selection, colorCode: colorCode))
        case .tolerance:
            return AnyView(THTToleranceSelectionView(selection: $selection, colorCode: colorCode))
        case .digit(let index):
            return AnyView(THTDigitSelectionView(selection: $selection, colorCode: colorCode, significantDigit: index))
        }
    }
    
    var body: some View {
        let colorCode = Binding<ColorCode> (
            get: {
                self.code.colorCode(significantDigits: self.significantDigits)
        },
            set: {
                self.code.update(colorCode: $0)
        })

        return VStack {
            HStack(alignment: .top) {
                THTDigitRingsView(colorCode: colorCode, selection: $selection)
                THTMultiplierRingView(colorCode: colorCode, selection: $selection)
                THTToleranceRingView(colorCode: colorCode, selection: $selection)
            }
            .frame(maxHeight: 50)
            selectionView(colorCode: colorCode)
        }
    }

    struct CodeView_Previews: PreviewProvider {

        static var previews: some View {
            THTCodeView(significantDigits: .constant(3)).environmentObject(Code(value: 27_000)!)
        }
    }
}

struct THTMultiplierRingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var colorCode: ColorCode
    @Binding var selection: Selection

    var body: some View {
        RingView(color: colorCode.multiplier.color,
                 isSelected: self.selection == .multiplier, gradient: colorCode.multiplier.highlight)
            .onTapGesture {
                if self.selection == .multiplier {
                    self.selection = .none
                }
                else {
                    self.selection = .multiplier
                }
        }
    }
}

struct THTToleranceRingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var colorCode: ColorCode
    @Binding var selection: Selection

    var body: some View {
        RingView(color: colorCode.tolerance.color, isSelected: self.selection == .tolerance, gradient: colorCode.tolerance.highlight)
            .onTapGesture {
                if self.selection == .tolerance {
                    self.selection = .none
                }
                else {
                    self.selection = .tolerance
                }
        }
    }
}

struct THTDigitRingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var colorCode: ColorCode
    @Binding var selection: Selection

    func isSelected(digit: Int) -> Bool {
        switch self.selection {
        case .digit(let selectedDigit):
            return digit == selectedDigit ? true : false
        default:
            return false
        }
    }

    var body: some View {
        ForEach(Array(colorCode.digits.enumerated()), id: \.offset) { index, digit in
            RingView(color: digit.color, isSelected: self.isSelected(digit: index), gradient: nil)
                    .onTapGesture {
                        if self.isSelected(digit: index) {
                            self.selection = .none
                        }
                        else {
                            self.selection = .digit(index)
                        }
                }
        }
    }
}

struct RingView: View {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let isSelected: Bool
    let gradient: Color?

    var body: some View {
        Group {
        if gradient != nil {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [color, gradient!, color]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .border(self.colorScheme == .dark ? Color.white  : Color.gray,
                        width: isSelected ? 2.5 : 1.0)
        }
        else {
            Rectangle()
            .fill(color)
                .border(self.colorScheme == .dark ? Color.white  : Color.gray,
                        width: isSelected ? 2.5 : 1.0)
        }
        }
    }
}
