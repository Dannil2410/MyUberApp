//
//  HomeView.swift
//  UberApp
//
//  Created by Даниил Кизельштейн on 08.11.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var mapState: MapViewState = .noInput
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                    .blur(
                        radius: mapState == .locationSearch ? 8 : 0
                    )
                    .disabled(mapState == .locationSearch)
                
                if mapState == .locationSearch {
                    LocationSearchView(mapState: $mapState)
                } else {
                    LocationSearchActivationView(mapState: $mapState)
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .locationSearch
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
            .zIndex(2)
            
            if mapState == .selectedLocation || mapState == .polylineAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
                    .zIndex(3)
            }

        }
        .zIndex(1)
        .ignoresSafeArea(edges: .bottom)
        .onReceive(locationManager.$userLocation) { location in
            if let location = location {
                locationSearchViewModel.setUserLocation(coordinate: location)
            }
        }
    }
}

#Preview {
    HomeView()
}
