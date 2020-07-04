//
//  SMDContentView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

struct SMDContentView: View {
    @State var numberOfDigits: Int = 3

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ResistorInputView(showTolerances: false)) {
                    SMDValueView()
                }
                SMDDigitPicker(numberOfDigits: $numberOfDigits)
                SMDCodeView(digitCount: $numberOfDigits)
                    .navigationBarTitle("SMD Resistor Code", displayMode: .inline)
                Spacer()
            }.padding()
        }
    }
}

struct SMDDigitPicker: View {
    @Binding var numberOfDigits: Int

    var body: some View {
        Picker("Rings", selection: $numberOfDigits) {
            Text("3 Digits").tag(3)
            Text("4 Digits").tag(4)
        }.pickerStyle(SegmentedPickerStyle())
    }

}

struct SMDValueView: View {
    @EnvironmentObject var code: Code

    let ohmFormatter: MeasurementFormatter = {
        let f = MeasurementFormatter()
        f.unitOptions = .providedUnit
        return f
    }()

    var body: some View {
        Text(ohmFormatter.string(from: code.scaledOhms))
    }
}

struct SMDContenView_Previews: PreviewProvider {
    static var previews: some View {
        SMDContentView().environmentObject(Code(value: 48_000)!)
    }
}
