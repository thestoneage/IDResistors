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
    @State var sheet: ContentViewSheet?
    
    @ObservedObject var inputModel = InputModel()
    @EnvironmentObject var code: Code


    let ohmFormatter: MeasurementFormatter = {
        let f = MeasurementFormatter()
        f.unitOptions = .providedUnit
        return f
    }()

    let navigationBarTitle = NSLocalizedString("SMD Resistor Code",
                                comment: "Title of SMD Content View on Navigation Bar")

    var body: some View {
        NavigationView {
            VStack {
                Button(ohmFormatter.string(from: code.scaledOhms)) {
                    sheet = .input
                }
                SMDDigitPicker(numberOfDigits: $numberOfDigits)
                SMDCodeView(digitCount: $numberOfDigits)
                    .navigationBarTitle(
                        Text(navigationBarTitle),
                        displayMode: .inline)
                Spacer()
            }.padding()
            .sheet(item: $sheet) { item in
                switch item {
                case .input:
                    NavigationView {
                        ResistorInputView(model: inputModel, showTolerances: false)
                            .navigationBarItems(leading: Button("Dismiss") {
                                sheet = nil
                            }, trailing: Button("Set Value") {
                                self.code.value = self.inputModel.value
                                sheet = nil
                            }.disabled(self.inputModel.formInvalid)
                            )
                    }
                case .presets:
                    PresetView()
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: { sheet = .presets }) {
                Image(systemName: "list.bullet")
            })
        }
    }
}

struct SMDDigitPicker: View {
    @Binding var numberOfDigits: Int

    private let pickerTitle = NSLocalizedString("Digits",
                                comment: "Title of digit Picker")
    private let pickerItemTitle3D = NSLocalizedString("3 Digits",
                                comment: "Title of Picker Item")
    private let pickerItemTitle4D = NSLocalizedString("4 Digits",
                                comment: "Title of Picker Item")

    var body: some View {
        Picker(pickerTitle, selection: $numberOfDigits) {
            Text(pickerItemTitle3D).tag(3)
            Text(pickerItemTitle4D).tag(4)
        }.pickerStyle(SegmentedPickerStyle())
    }

}

struct SMDContenView_Previews: PreviewProvider {
    static var previews: some View {
        SMDContentView().environmentObject(Code(value: 48_000)!)
    }
}
