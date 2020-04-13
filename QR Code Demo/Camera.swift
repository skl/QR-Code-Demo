//
//  Camera.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI

class Camera: Identifiable, Codable {
    let id = UUID()
    var name = "Unlabelled camera"
    var isOnline = false
}

class Cameras: ObservableObject {
    @Published var cameras: [Camera]
    
    init() {
        self.cameras = []
    }
}
