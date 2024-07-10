//
//  MeView.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 09/07/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {
    @AppStorage("name") private var name = ""
    @AppStorage("emailAddress") private var email = ""
    @State private var isEditing = false
    
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Section {
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                        
                    }
                    .padding(.vertical, 6)
                    .textFieldStyle(.roundedBorder)
                    .customBorder()
                    .padding(.horizontal)
                    
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.vertical, 50)
                        .contextMenu {
                            ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                        }
                    Spacer()
                }
                .scrollBounceBehavior(.basedOnSize)
                .ignoresSafeArea(.keyboard)
                .navigationTitle("Your QR")
                .onAppear(perform: updateCode)
                .onChange(of: name, updateCode)
                .onChange(of: email, updateCode)
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(email)")
    }
}

#Preview {
    MeView()
}
