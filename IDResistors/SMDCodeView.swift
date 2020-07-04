//
//  SMDCodeView.swift
//  IDResistors
//
//  Created by Marc Rummel on 08.06.20.
//  Copyright © 2020 Marc Rummel.
//  This code is licensed under MIT license (see LICENSE.txt for details)
//

import SwiftUI
import Combine

class SMDCodeModel: ObservableObject {
    @Published var input  = ""
    @Published var inInputMode = false
    var offset = 0

    func enterInputMode(numberOfDigits: Int) {
        self.input = String(repeating: "_", count: numberOfDigits)
        self.offset = 0
        self.inInputMode = true
    }

    func appendCharacter(character: String) {
        let index = input.index(input.startIndex, offsetBy: offset)
        self.input.replaceSubrange(index...index , with: character)
        self.offset += 1
        if input.index(input.startIndex, offsetBy: offset) == input.endIndex {
            inInputMode = false
        }
    }

    func delete() {
        guard self.offset > 0 else { return }
        self.offset -= 1
        let index = input.index(input.startIndex, offsetBy: self.offset)
        input.replaceSubrange(index...index , with: "_")
    }
}

struct SMDCodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var code: Code
    @Binding var digitCount: Int
    
    @ObservedObject var model = SMDCodeModel()
    @State var test: String = "ABC"

    var text: String {
        if (model.inInputMode) {
            return model.input
        }
        else {
            return code.smdCode(digits: self.digitCount)
        }
    }

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text(text)
                    .padding(.horizontal)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .border(colorScheme == .dark ? Color.white  : Color.clear)
                    .onTapGesture {
                        self.model.enterInputMode(numberOfDigits: self.digitCount)
                }.onReceive(self.model.$input) { input in
                        self.code.update(smdCode: self.model.input)
                }
                Spacer()
            }
            if model.inInputMode {
                NSMDInputView(inputModel: model)
            }
            Spacer()
        } 
    }
}

struct NSMDDigitView: View {
    let text: String
    @ObservedObject var inputModel: SMDCodeModel

    var body: some View {
        Button(action: {
            if self.text == "⌫" {
                self.inputModel.delete()
            }
            else {
                self.inputModel.appendCharacter(character: self.text)
            }}) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder()
                Text(text)
                    .bold()
            }
        }
    }
}

struct NSMDInputView: View {
    @ObservedObject var inputModel: SMDCodeModel

    var body: some View {
        VStack {
            ForEach(0...2, id: \.self) { i in
                HStack {
                    ForEach(1...3, id: \.self) { j in
                        NSMDDigitView(text: String( i * 3 + j ), inputModel: self.inputModel)
                    }
                }
            }
            HStack {
                NSMDDigitView(text: "R", inputModel: inputModel)
                NSMDDigitView(text: "0", inputModel: inputModel)
                NSMDDigitView(text: "⌫", inputModel: inputModel)
            }
        }.padding()
    }
}

struct SMDDigitView_Previews: PreviewProvider {
    static var previews: some View {
        NSMDInputView(inputModel: SMDCodeModel()).environmentObject(Code(value: 27_000)!)
    }
}


struct NSMDCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SMDCodeView(digitCount: .constant(3)).environmentObject(Code(value: 27_000)!)
    }
}
