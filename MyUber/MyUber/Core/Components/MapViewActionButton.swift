//
//  MapViewActionButton.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 09.11.2023.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var mapState: MapViewState
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            actionButtonLabel
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension MapViewActionButton {
    private var actionButtonLabel: some View {
        Image(
            systemName: imageNameForState(mapState))
            .font(.title2)
            .foregroundStyle(Color .black)
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: Color.black, radius: 10)
    }
    
    private func actionForState(_ state: MapViewState) {
            switch state {
            case .noInput:
                print("DEBUG: No input")
            case .locationSearch:
                withAnimation {
                    mapState = .noInput
                }
            case .selectedLocation, .polylineAdded:
                locationSearchViewModel.selectedLocation = nil
                locationSearchViewModel.cancelSubscription()
                withAnimation {
                    mapState = .noInput
                }
            }
    }
    
    private func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .locationSearch, .selectedLocation, .polylineAdded:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
