//
//  ContentView.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI
import OneTimePassword

struct ContentView: View {
    @ObservedObject var tokens = Tokens(keychain: Keychain.sharedInstance)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        OTPView()
            .environmentObject(tokens)
            .onReceive(timer) { time in
                self.tokens.emitChangeEvent()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
