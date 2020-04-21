//
//  OTPView.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 14/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI
import CodeScanner
import OneTimePassword

struct OTPView: View {
    @EnvironmentObject var tokens: Tokens
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tokens.tokens) { token in
                    VStack(alignment: .leading) {
                        Text(token.token.currentPassword!)
                            .font(.largeTitle)
                        Text(token.token.issuer)
                        Text(token.token.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle("Your accounts")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example", completion: self.handleScan)
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        self.tokens.remove(atOffsets: offsets)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let urlString):
            guard let tokenURL = URL(string: urlString) else { return }
            guard let token = Token(url: tokenURL) else { return }
            let decoratedToken = TokenDecorator(token: token, identifier: nil)
            
            let numDuplicates = self.tokens.tokens.filter {
                $0.id == decoratedToken.id
            }.count
            
            if numDuplicates == 0 {
                self.tokens.append(token: decoratedToken, persist: true)
            } else {
                print("Ignored dulicate token")
            }
        case .failure:
            print("Scanning failed")
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
