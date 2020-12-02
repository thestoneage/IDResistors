//
//  PresetView.swift
//  IDResistors
//
//  Created by Marc Rummel on 01.12.20.
//  Copyright © 2020 Marc Rummel. All rights reserved.
//

import SwiftUI

struct PresetView: View {
    @AppStorage(CodePreset.key) var presets: [CodePreset] = CodePreset.initialPresets
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var code: Code
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(presets, id: \.self.id) { preset in
                    Text(preset.value.description)
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
