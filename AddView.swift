//
//  AddView.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 13/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct AddView: View {
    @State private var name = "Unlabelled camera"
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    .padding(.horizontal)
                
                Image(uiImage: generateQRCode(from: name))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
            }
            .navigationBarTitle("Add camera")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
