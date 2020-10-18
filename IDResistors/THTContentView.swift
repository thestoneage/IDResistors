//
//  THTContentView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI


extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .top).combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct THTContentView: View {
    @EnvironmentObject var code: Code
    @State var significantDigits:Int = 2
    @State var showInput: Bool = false

    let pickerTitle = NSLocalizedString("Rings", comment: "Title of ring picker")
    let pickerItemTitle4R = NSLocalizedString("4 Rings", comment: "Title of 4 rings picker")
    let pickerItemTitle5R = NSLocalizedString("5 Rings", comment: "Title of 5 rings picker")
    let navigationBarTitle = NSLocalizedString("Resistor Color Code", comment: "Title of THTContentView")

    var measurementFormatter: MeasurementFormatter {
        let f = MeasurementFormatter()
        f.unitOptions = .providedUnit
        return f
    }

    var resistorText: String {
        "\(measurementFormatter.string(from: code.scaledOhms)) \(code.toleranceRing.string)"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Button(resistorText) {
                    showInput = true
                }
                Picker(pickerTitle, selection: $significantDigits.animation()) {
                    Text(pickerItemTitle4R).tag(2)
                    Text(pickerItemTitle5R).tag(3)
                }.pickerStyle(SegmentedPickerStyle())
                    .navigationBarTitle(
                        Text(navigationBarTitle), displayMode: .inline)
                THTCodeView(significantDigits: $significantDigits)
                Spacer()
            }.padding()
            .sheet(isPresented: $showInput) {
                ResistorInputView(showTolerances: true)
            }
        }
    }
}

struct CodeContentView_Previews: PreviewProvider {
    static var previews: some View {
        THTContentView().environmentObject(Code(value: 27_000)!)
    }
}
