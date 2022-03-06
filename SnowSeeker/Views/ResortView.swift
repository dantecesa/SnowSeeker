//
//  ResortDetailView.swift
//  SnowSeeker
//
//  Created by Dante Cesa on 3/5/22.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @EnvironmentObject var favorites: Favorites
    
    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(resort.id)
                    .resizable()
                    .scaledToFit()
                
                Group {
                    HStack {
                        if horizontalSizeClass == .compact && dynamicTypeSize > .large {
                            VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                            VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        } else {
                            SkiDetailsView(resort: resort)
                            ResortDetailsView(resort: resort)
                        }
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                        .padding(.vertical)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            HStack {
                                Button {
                                    selectedFacility = facility
                                    showingFacility = true
                                } label: {
                                    facility.icon
                                    
                                    Text(facility.name.uppercased())
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.primary.opacity(0.5))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.leading)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .alert(selectedFacility?.name ?? "More Information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if favorites.contains(resort) {
                    Button(action: {
                        favorites.remove(resort)
                    }, label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    })
                } else {
                    Button(action: {
                        favorites.add(resort)
                    }, label: {
                        Image(systemName: "star")
                            .foregroundColor(.secondary)
                    })
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResortDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
    }
}
