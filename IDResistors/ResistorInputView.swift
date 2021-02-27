//
//  ResistorInputView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

struct InputResistorModel {
    private let formatter = NumberFormatter()
    
    let tolerances = ToleranceRing.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    var toleranceIndex: Int = 2
    var toleranceValue: Double {
        toleranceRing.rawValue
    }
    var toleranceString: String {
        toleranceRing.string
    }
    var toleranceRing: ToleranceRing {
        tolerances[toleranceIndex]
    }

    var scale: Int = 1
    
    var resistor: String = ""
    var resistorValue: Double? {
        return formatter.number(from: resistor)?.doubleValue
    }
    var value: Double {
        Double(scale) * (resistorValue ?? 0.0)
    }
    
    var inputIsValid: Bool {
        return resistorValue != nil
    }
    
    mutating func reset() {
        scale = 1
        resistor = ""
        toleranceIndex = 2
    }
    
}

struct ResistorInputView: View {
    @Binding var model: InputResistorModel

    var showTolerances: Bool

    private let stepperTitle = NSLocalizedString("Tolerance",
                        comment: "Tolerance steppter title")
    private let textFieldTitle = NSLocalizedString("Enter Value:",
                        comment: "Title of Textfield to enter a resistor value")
    private let pickerTitle = NSLocalizedString("Unit",
                        comment: "Unit of input value")
    private let buttonTitle = NSLocalizedString("Set Resistor Value",
                        comment: "Button title to set the value of the resistor")
    private let title = NSLocalizedString("Resistor Value",
                        comment: "Headline of Resistor input view.")

    private let invalidInputMessage = NSLocalizedString("Enter a decimal number",
                                                 comment: "Message when you input a resitor value.")

    var body: some View {
        Form {
            Section(footer: Text(model.inputIsValid ? "" : invalidInputMessage)) {
                TextField(textFieldTitle, text: $model.resistor)
                    .keyboardType(.decimalPad)
                Picker(pickerTitle, selection: $model.scale) {
                    Text("Ω").tag(1)
                    Text("kΩ").tag(1000)
                    Text("MΩ").tag(1000000)
                }.pickerStyle(SegmentedPickerStyle())
                if showTolerances {
                    Stepper("\(stepperTitle) \(model.toleranceString)", value: $model.toleranceIndex, in: 0...model.tolerances.count - 1)
                }
            }
        }.navigationTitle(title)
        .onAppear {
            model.reset()
        }
    }
}

struct ResistorInputView_Previews: PreviewProvider {
    static var previews: some View {
        ResistorInputView(model: .constant(InputResistorModel()), showTolerances: false).environmentObject(Code(value: 27_000)!)
    }
}
