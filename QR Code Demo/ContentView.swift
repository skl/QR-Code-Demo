//
//  ContentView.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var cameras = Cameras()
    
    var body: some View {
        TabView {
            CamerasView(filter: .none)
                .tabItem {
                    Image(systemName: "video.circle")
                    Text("All")
            }
            CamerasView(filter: .online)
                .tabItem {
                    Image(systemName: "video.fill")
                    Text("Online")
            }
            CamerasView(filter: .offline)
                .tabItem {
                    Image(systemName: "video.slash.fill")
                    Text("Offline")
            }
            AddView()
                .tabItem {
                    Image(systemName: "video.badge.plus.fill")
                    Text("Add")
            }
        }.environmentObject(cameras)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
