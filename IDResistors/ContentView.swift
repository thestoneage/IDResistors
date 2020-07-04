//
//  ContentView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var code: Code

    var body: some View {
        TabView {
            THTContentView()
                .tabItem{
                    Image(uiImage:
                        UIImage(named: "THT.fill",
                                in: nil,
                                with: UIImage.SymbolConfiguration(scale: .large))!)
                    Text("THT")
            }
            SMDContentView()
                .tabItem {
                    Image(uiImage:
                        UIImage(named: "SMD.fill",
                                in: nil,
                                with: UIImage.SymbolConfiguration(scale: .large))!)
                    Text("SMD")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Code(value: 27_000)!)
    }
}
