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
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        OTPView().environmentObject(tokens).alert(isPresented: $appState.showAlert) {
            Alert(title: Text("Approve sign-in?"),
                  message: Text(self.appState.lastSignInRequest.account),
                  primaryButton: .default(Text("Approve")) {
                    ApiStub.approved(request: self.appState.lastSignInRequest)
                }, secondaryButton: .destructive(Text("Deny")){
                    ApiStub.denied(request: self.appState.lastSignInRequest)
                })
        }
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
