//
//  CamerasView.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI
import CodeScanner

struct CamerasView: View {
    enum FilterType {
        case none, online, offline
    }
    
    @EnvironmentObject var cameras: Cameras
    @State private var isShowingScanner = false
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "All Cameras"
        case .online:
            return "Online Cameras"
        case .offline:
            return "Offline Cameras"
        }
    }
    
    var filteredCameras: [Camera] {
        switch filter {
        case .none:
            return cameras.cameras
        case .online:
            return cameras.cameras.filter { $0.isOnline }
        case .offline:
            return cameras.cameras.filter { !$0.isOnline }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCameras) { camera in
                    VStack(alignment: .leading) {
                        Text(camera.name)
                            .font(.headline)
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Unlabelled camera", completion: self.handleScan)
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            let camera = Camera()
            camera.name = code
            
            self.cameras.cameras.append(camera)
        case .failure:
            print("Scanning failed")
        }
    }
}

struct CamerasView_Previews: PreviewProvider {
    static var previews: some View {
        CamerasView(filter: .none)
    }
}
