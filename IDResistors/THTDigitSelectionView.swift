//
//  THTDigitSelectionView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

extension DigitRing: ColorConvertable {
    var highlight: Color? {
        return nil
    }

    var color: Color {
        switch self {
        case .black:
            return Colors.black
        case .blue:
            return Colors.blue
        case .brown:
            return Colors.brown
        case .gray:
            return Colors.gray
        case .green:
            return Colors.green
        case .orange:
            return Colors.orange
        case .red:
            return Colors.red
        case .violet:
            return Colors.violet
        case .white:
            return Colors.white
        case .yellow:
            return Colors.yellow
        }
    }
}

struct THTDigitSelectionView: View {
    @Binding var selection: Selection
    @Binding var colorCode: ColorCode
    var significantDigit: Int
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            ForEach(DigitRing.allCases) { digit in
                RingSelectionView(color: digit.color,
                                  text: "\(digit.rawValue)",
                    gradient: nil)
                .onTapGesture {
                withAnimation {
                    self.colorCode.digits[self.significantDigit] = digit
                    self.selection = .none
                    }
                }
            }
        }
    }
}

struct RingSelectionView: View {
    @Environment(\.colorScheme) var colorScheme
    let color: Color
    let text: String
    let gradient: Color?
    

    var body: some View {
        ZStack(alignment: .center) {
            if gradient != nil {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [color, gradient!, color, gradient!, color]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .border(self.colorScheme == .dark ? Color.white  : Color.gray)
            }
            else {
                Rectangle().fill(color)
                    .border(self.colorScheme == .dark ? Color.white  : Color.gray)
            }
            Text(text)
                .foregroundColor(color == Color.black ? Color.white : Color.black)

        }
    }
}

struct DigitView_Previews: PreviewProvider {
    static var previews: some View {
        THTDigitSelectionView(selection: .constant(.none), colorCode: .constant(ColorCode(digits: [.blue, .red], multiplier: .green, tolerance: .gold)), significantDigit: 2)
    }
}
