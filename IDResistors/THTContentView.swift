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
                    NavigationLink(destination: ResistorInputView(showTolerances: true)) {
                        Text(resistorText)
                    }
                    Picker("Rings", selection: $significantDigits.animation()) {
                        Text("4 Rings").tag(2)
                        Text("5 Rings").tag(3)
                    }.pickerStyle(SegmentedPickerStyle())
                        .navigationBarTitle("Resistor Color Code", displayMode: .inline)
                    THTCodeView(significantDigits: $significantDigits)
                    Spacer()
                }.padding()
        }
    }
}

struct CodeContentView_Previews: PreviewProvider {
    static var previews: some View {
        THTContentView().environmentObject(Code(value: 27_000)!)
    }
}
