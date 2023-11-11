//
//  LocationSearchView.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import SwiftUI

struct LocationSearchView: View {
    
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    @State var currentLocationText: String = ""
    @Binding var mapState: MapViewState
    
    var body: some View {
        VStack {
            // headerView
            
            headerView
                .padding(.horizontal)
                .padding(.top, 64)
            
            Divider()
                .padding(.vertical)
            
            // listView
            List(locationSearchViewModel.results, id: \.self) { result in
                LocationSearchResultCell(
                    title: result.title,
                    subTitle: result.subtitle
                )
                .listRowBackground(Color.theme.background.opacity(0.7))
                .onTapGesture {
                    withAnimation {
                        locationSearchViewModel.selectLocation(result)
                        mapState = .selectedLocation
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

extension LocationSearchView {
    
    private var headerView: some View {
        HStack {
            IndicatorView(indicatorSide: 6, lineHeight: 24)
            locationTextFields
        }
    }
    
    private var locationTextFields: some View {
        VStack {
            TextField("Current Location", text: $currentLocationText)
                .frame(height: 32)
                .background(Color(.systemGroupedBackground))
                .disabled(true)
            
            TextField(
                "Destination Location",
                text: $locationSearchViewModel.queryFragment
            )
            .frame(height: 32)
            .background(Color(.systemGray4))
        }
    }

}

#Preview {
    LocationSearchView(mapState: .constant(.locationSearch))
}
