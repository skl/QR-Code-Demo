//
//  AppState.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 20/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI

class AppState: ObservableObject {
    struct SignInRequest {
        var account: String
        var issuer: String
    }
    
    @Published var showAlert: Bool = false
    @Published var lastSignInRequest: SignInRequest
    
    init() {
        lastSignInRequest = SignInRequest(
            account: "",
            issuer: ""
        )
    }
}
