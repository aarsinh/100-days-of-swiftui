//
//  ContentView.swift
//  Instafilter
//
//  Created by Aarav Sinha on 27/06/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @AppStorage("FilterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var showingFilters = false
    @State private var rotation = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(rotation))
                    }
                    
                    else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                if processedImage != nil {
                    VStack(alignment: .leading) {
                        if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                            HStack {
                                Text("Intensity")
                                Slider(value: $filterIntensity)
                                    .onChange(of: filterIntensity, applyProcessing)
                            }
                        }
                        
                        if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                            HStack {
                                ZStack(alignment: .leading) {
                                    Text("Intensity").opacity(0)
                                    Text("Radius")
                                }
                                Slider(value: $filterRadius)
                                    .onChange(of: filterRadius, applyProcessing)
                            }
                        }
                        
                        if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                            HStack {
                                ZStack(alignment: .leading) {
                                    Text("Intensity").opacity(0)
                                    Text("Scale")
                                }
                                Slider(value: $filterScale)
                                    .onChange(of: filterScale, applyProcessing)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Button("\(currentFilter.formattedName)", action: changeFilter)
                        .frame(width: 150, height: 50)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            
            .toolbar {
                if let processedImage {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("rotate image", systemImage: "rotate.right") {
                            withAnimation {
                                rotation += 90
                            }
                            if rotation >= 360 {
                                rotation = 0.0
                            }
                        }
                    }
                }
                
                ToolbarItem {
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter Image", image: processedImage))
                            .labelStyle(.iconOnly)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Instafilter")
                            .font(.title)
                            .bold()
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Bloom") { setFilter(CIFilter.bloom())}
                Button("Cancel", role: .cancel) { }
            }
            
        }
        
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 100, forKey: kCIInputScaleKey)}
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount % 20 == 0 {
            requestReview()
        }
    }
}

extension CIFilter {
    var formattedName: String {
        return name
                .replacingOccurrences(of: "CI", with: "")
                .replacingOccurrences(of: "(?<!^)([A-Z])", with: " $1", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
        
    }
}

#Preview {
    ContentView()
}
