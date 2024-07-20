//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 20/07/24.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(Favourites.self) var favourites
    
    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var isShowingFacility = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading) {
                        Image(decorative: resort.id)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                        
                        Text("Photo by: \(resort.imageCredit)")
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        if horizontalSizeClass == .compact && dynamicTypeSize > .large {
                            VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                            VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                        } else {
                            ResortDetailsView(resort: resort)
                            SkiDetailsView(resort: resort)
                        }
                            
                    }
                    .padding(.vertical)
                    .background(.primary.opacity(0.1))
                    
                    Group {
                        Text(resort.description)
                            .padding(.vertical)
                        
                        Text("Facilities")
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            ForEach(resort.facilityTypes) { facility in
                                Button {
                                    selectedFacility = facility
                                    isShowingFacility = true
                                } label : {
                                    facility.icon
                                        .font(.title)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Favourite/Unfavourite", systemImage: favourites.contains(resort) ? "heart.fill" : "heart") {
                        if favourites.contains(resort) {
                            favourites.remove(resort)
                        } else {
                            favourites.add(resort)
                        }
                    }
                    
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("\(resort.name), \(resort.country)")
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(selectedFacility?.name ?? "More information", isPresented: $isShowingFacility, presenting: selectedFacility) { _ in
            } message: { facility in
                Text(facility.description)
            }
        }
    }
}

#Preview {
    ResortView(resort: .example)
}
