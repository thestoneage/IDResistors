//
//  THTToleranceSelectionView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

struct THTToleranceSelectionView: View {
    @Binding var selection: Selection
    @Binding var colorCode: ColorCode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ForEach(ToleranceRing.allCases) { tolerance in
                RingSelectionView(color: tolerance.color, text: tolerance.string, gradient: tolerance.highlight)
                .onTapGesture {
                        withAnimation {
                            self.colorCode.tolerance = tolerance
                            self.selection = .none
                        }
                }
            }
        }
    }
}

extension ToleranceRing: ColorConvertable {
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
        case .blue:
            return Colors.blue
        case .brown:
            return Colors.brown
        case .red:
            return Colors.red
        case .orange:
            return Colors.orange
        case .yellow:
            return Colors.yellow
        case .green:
            return Colors.green
        case .violet:
            return Colors.violet
        case .gray:
            return Colors.gray
        case .silver:
            return Colors.silver
        case .gold:
            return Colors.gold
        }
    }
}

struct ToleranceView_Previews: PreviewProvider {
    static var previews: some View {
        THTToleranceSelectionView(selection: .constant(.none), colorCode: .constant(ColorCode(digits: [.red, .blue], multiplier: .brown, tolerance: .gold)))
    }
}
