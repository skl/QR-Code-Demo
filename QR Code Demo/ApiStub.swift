//
//  ApiStub.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 20/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI

struct ApiStub {
    static func approved(request: AppState.SignInRequest) {
        print("ApiStub::approved() \(String(describing:request))")
    }
    
    static func denied(request: AppState.SignInRequest) {
        print("ApiStub::denied() \(String(describing:request))")
    }
}
