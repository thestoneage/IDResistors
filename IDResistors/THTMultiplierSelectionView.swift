//
//  THTMultiplierSelectionView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

struct THTMultiplierSelectionView: View {
    @Binding var selection: Selection
    @Binding var colorCode: ColorCode
    @Environment(\.colorScheme) var colorScheme
    
    var formatter: NumberFormatter {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        return fmt
    }
    
    func multiplierText(multiplier: MultiplierRing) -> String {
        let number = pow(10,Double(multiplier.rawValue))
        let nsnumber = NSNumber(value: number)
        let string = formatter.string(from: nsnumber)!
        let text = "× " + string
        return text
    }
    
    var body: some View {
        VStack {
            ForEach(MultiplierRing.allCases) { multiplier in
                RingSelectionView(color: multiplier.color,
                                  text: self.multiplierText(multiplier: multiplier), gradient: multiplier.highlight)
                .onTapGesture {
                        withAnimation {
                            self.colorCode.multiplier = multiplier
                            self.selection = .none
                        }
                }
            }
        }
    }
}

extension MultiplierRing: ColorConvertable {
    var highlight: Color? {
        switch self {
        case .gold:
            return Colors.goldHighlight
        case .silver:
            return Colors.silverHighlight
        default:
            return nil
        }
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
            return Color.orange
        case .red:
            return Colors.red
        case .violet:
            return Colors.violet
        case .white:
            return Colors.white
        case .yellow:
            return Colors.yellow
        case .gold:
            return Colors.gold
        case .silver:
            return Colors.silver
        }
    }
}

struct MultiplierView_Previews: PreviewProvider {
    static var previews: some View {
        THTMultiplierSelectionView(selection: .constant(.none), colorCode: .constant(ColorCode(digits: [.red, .blue], multiplier: .brown, tolerance: .gold)))    }
}
