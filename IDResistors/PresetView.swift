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
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .overlay(
            HStack {
                Spacer()
                SMDCodePresetView(preset: preset)
                ColorCodeView(code:
                                Code.colorCode(preset.value.converted(to: UnitElectricResistance.ohms).value,
                                               significantDigits: 3,
                                               tolerance: preset.tolerance))
                
            }
        )
    }
}

struct SMDCodePresetView: View {
    var preset: CodePreset
    
    var codeString: String {
        let value = preset.value.converted(to: UnitElectricResistance.ohms).value
        return Code.smdCode(value, digits: 3)
    }
    
    var body: some View {
        Text(codeString)
            .fontWeight(.bold)
            .padding(.horizontal)
            .background(Color.black)
            .foregroundColor(.white)
    }
}

struct ColorCodeView: View {
    var code: ColorCode
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(code.digits, id: \.self) { digit in
                Rectangle()
                    .fill(digit.color)
            }.aspectRatio(1.0, contentMode: .fit)
            Rectangle()
                .fill(code.multiplier.color)
                .aspectRatio(1.0, contentMode: .fit)
            Rectangle()
                .fill(code.tolerance.color)
                .aspectRatio(1.0, contentMode: .fit)
        }
    }
}

struct PresetView: View {
    @AppStorage(CodePreset.key) var presets: [CodePreset] = CodePreset.initialPresets
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var code: Code
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach(Array(zip(presets.indices, presets)), id: \.0) { (index, preset) in
                        PresetCell(preset: preset)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                code.preset = preset
                                presentationMode.wrappedValue.dismiss()
                            }
                            .id(index)
                    }
                    .onDelete { indexSet in
                        presets.remove(atOffsets: indexSet)
                    }
                    .onMove(perform: move)
                    .onChange(of: presets.count) { _ in
                        proxy.scrollTo(presets.count - 1)
                    }
                }
                .navigationTitle("Presets")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            let newPreset = CodePreset(value: code.ohms, tolerance: code.toleranceRing)
                            presets.append(newPreset)
                        })
                        {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .environment(\.editMode, $editMode)
            }
            
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        presets.move(fromOffsets: source, toOffset: destination)
    }
}

struct PresetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PresetView()
            PresetView()
        }
    }
}
