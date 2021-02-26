//
//  ResistorInputView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI
import Combine

class InputModel: ObservableObject {
    @Published var valueText: String = ""
    @Published var valueScale: Int = 1
    @Published var formInvalid:Bool = true

    var valueMessage = ""
    var value: Double = 0.0
    
    @Published var tolerance: Int = 2
    var toleranceRing: ToleranceRing = .gold
    let tolerances = ToleranceRing.allCases.sorted(by: { $0.rawValue < $1.rawValue })

    private var cancellableSet: Set<AnyCancellable> = []
    private let formatter = NumberFormatter()

    private let inputMessage = NSLocalizedString("Enter a decimal number", comment: "Message when you input a resitor value.")

    private var numberValuePublisher: AnyPublisher<Double?, Never> {
        $valueText
            .removeDuplicates()
            .map { input in
                self.formatter.number(from: input)?.doubleValue
            }
            .eraseToAnyPublisher()
    }
    
    private var toleranceValuePublisher: AnyPublisher<ToleranceRing, Never> {
        $tolerance
            .removeDuplicates()
            .map { input in
                self.tolerances[input]
            }.eraseToAnyPublisher()
    }

    private var doubleValuePublisher: AnyPublisher<Double, Never> {
        numberValuePublisher.compactMap { $0 }
        .eraseToAnyPublisher()
    }

    private var isValueInvalidPublisher: AnyPublisher<Bool, Never> {
        numberValuePublisher.map {
            $0 == nil
        }.eraseToAnyPublisher()
    }

    private var valuePublisher: AnyPublisher<Double, Never> {
        Publishers.CombineLatest(doubleValuePublisher, $valueScale)
            .map { value, scale in
                return value * Double(scale)
        }.eraseToAnyPublisher()
    }

    init() {
        isValueInvalidPublisher
            .assign(to: \.formInvalid, on: self)
            .store(in: &cancellableSet)

        isValueInvalidPublisher
            .map {
                if $0 == true {
                    return self.inputMessage
                }
                else {
                    return ""
                }
            }
            .assign(to: \.valueMessage, on: self)
            .store(in: &cancellableSet)

        valuePublisher
            .assign(to: \.value, on: self)
            .store(in: &cancellableSet)
        
        toleranceValuePublisher
            .receive(on: RunLoop.main)
            .assign(to: \.toleranceRing, on: self)
            .store(in: &cancellableSet)
    }
}

struct ResistorInputView: View {
    @ObservedObject var model: InputModel

    var showTolerances: Bool

    private let textFieldTitle = NSLocalizedString("Enter Value:",
                        comment: "Title of Textfield to enter a resistor value")
    private let pickerTitle = NSLocalizedString("Unit",
                        comment: "Unit of input value")
    private let stepperTitle = NSLocalizedString("Tolerance",
                        comment: "Tolerance steppter title")
    private let buttonTitle = NSLocalizedString("Set Resistor Value",
                        comment: "Button title to set the value of the resistor")
    private let title = NSLocalizedString("Resistor Value",
                        comment: "Headline of Resistor input view.")
    
    var body: some View {
        Form {
            Section(footer: Text(model.valueMessage)) {
                TextField(textFieldTitle, text: $model.valueText)
                    .keyboardType(.decimalPad)
                Picker(pickerTitle, selection: $model.valueScale) {
                    Text("Ω").tag(1)
                    Text("kΩ").tag(1000)
                    Text("MΩ").tag(1000000)
                }.pickerStyle(SegmentedPickerStyle())
                if showTolerances {
                    Stepper("\(stepperTitle) \(model.tolerances[model.tolerance].string)", value: $model.tolerance, in: 0...(model.tolerances.count - 1))
                }
            }
        }.navigationTitle(title)
    }
}

struct SMDInputView_Previews: PreviewProvider {
    static var previews: some View {
        ResistorInputView(model: InputModel(), showTolerances: false).environmentObject(Code(value: 27_000)!)
    }
}
