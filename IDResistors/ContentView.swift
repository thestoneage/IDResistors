//
//  ContentView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @AppStorage(Keys.launchCounter) var launchCounter: Int = 0
    @AppStorage(Keys.latestVersionPromptedForReview) var latestVersionPromptedForReview: String?
    
    @EnvironmentObject var code: Code
    
    func requestReviewIfAppropiate() {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else { return }
        if launchCounter > 6 && latestVersionPromptedForReview != currentVersion {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                latestVersionPromptedForReview = currentVersion
            }
        }
    }
    
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
        }.onAppear {
            requestReviewIfAppropiate()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Code(value: 27_000)!)
    }
}
