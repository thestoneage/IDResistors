//
//  PresetView.swift
//  IDResistors
//
//  Created by Marc Rummel on 01.12.20.
//  Copyright © 2020 Marc Rummel. All rights reserved.
//

import SwiftUI
struct PresetCell: View {

    var preset: CodePreset
    
    static let ohmFormatter: MeasurementFormatter = {
        let f = MeasurementFormatter()
        f.unitOptions = .naturalScale
        return f
    }()

    var body: some View {
        HStack {
            Text(Self.ohmFormatter.string(from: preset.value))
            Spacer()
            CodeView(code:
                        Code.colorCode(preset.value.converted(to: UnitElectricResistance.ohms).value,
                                       significantDigits: 3,
                                       tolerance: preset.tolerance))
        }
    }
}

struct CodeView: View {
    var code: ColorCode
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(code.digits, id: \.self) { digit in
                Rectangle()
                    .fill(digit.color)
            }
            Rectangle()
                .fill(code.multiplier.color)
            Rectangle()
                .fill(code.tolerance.color)
        }.frame(maxWidth: 100)
    }
}

struct PresetView: View {
    @AppStorage(CodePreset.key) var presets: [CodePreset] = CodePreset.initialPresets
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var code: Code
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(presets, id: \.self.id) { preset in
                    PresetCell(preset: preset)
                        .onTapGesture {
                            code.preset = preset
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                .onDelete { indexSet in
                    presets.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Presets")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        //TODO: Create new preset
            })
            {
                Image(systemName: "plus")
            })
        }
    }
}

struct PresetView_Previews: PreviewProvider {
    static var previews: some View {
        PresetView()
    }
}