//
//  THTContentView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

enum ContentViewSheet: Identifiable {
    case presets
    case input
    
    var id: Int {
        hashValue
    }
}

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
    @State var sheet: ContentViewSheet?
        
    let pickerTitle = NSLocalizedString("Rings", comment: "Title of ring picker")
    let pickerItemTitle4R = NSLocalizedString("4 Rings", comment: "Title of 4 rings picker")
    let pickerItemTitle5R = NSLocalizedString("5 Rings", comment: "Title of 5 rings picker")
    let navigationBarTitle = NSLocalizedString("Resistor Color Code", comment: "Title of THTContentView")
    
    @State var newInput = InputResistorModel(resistor: "")
    
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
                    sheet = .input
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
            .sheet(item: $sheet) { item in
                switch item {
                case .input:
                    NavigationView {
                        ResistorInputView(model: $newInput, showTolerances: true)
                            .navigationBarItems(leading: Button("Dismiss") {
                                sheet = nil
                            }, trailing: Button("Set Value") {
                                self.code.value = self.newInput.value
                                self.code.toleranceRing = self.newInput.toleranceRing
                                sheet = nil
                            }.disabled(!self.newInput.inputIsValid)
                            )
                    }
                case .presets:
                    PresetView()
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {sheet = .presets}) {
                                        Image(systemName: "list.bullet")
                                    })
        }
    }
}

struct CodeContentView_Previews: PreviewProvider {
    static var previews: some View {
        THTContentView().environmentObject(Code(value: 27_000)!)
    }
}
