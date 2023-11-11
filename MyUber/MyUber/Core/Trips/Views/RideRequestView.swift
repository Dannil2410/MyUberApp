//
//  RideRequestView.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import SwiftUI

struct RideRequestView: View {
    @EnvironmentObject private var locationSearchViewModel: LocationSearchViewModel
    @State var selectedRideType: RideType = .uberX
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top)
            
            //trip info view
            tripInfoView
            
            Divider()
            
            //ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundStyle(Color(.systemGray))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            rideTypeSelectionView
            
            Divider()
                .padding(.vertical, 8)
            
            //payment option view
            
            paymentOptionView
            
            //request ride button
            
            requestRideButton
        }
        .padding(.bottom, 32)
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension RideRequestView {
    private var tripInfoView: some View {
        HStack {
            IndicatorView(indicatorSide: 6, lineHeight: 32)
                .padding(.trailing)
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Current Location")
                        .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    Text(locationSearchViewModel.pickUpTime ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.systemGray))
                }
                .padding(.bottom, 10)
                

                HStack {
                    Text(locationSearchViewModel.selectedLocation?.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Text(locationSearchViewModel.dropOffTime ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.systemGray))
                }
            }
        }
        .padding()
    }
    
    private var rideTypeSelectionView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(RideType.allCases) { type in
                    VStack(alignment: .leading) {
                        Image(type.imageName)
                            .resizable()
                            .scaledToFit()
                           
                        VStack(alignment: .leading, spacing: 4) {
                            Text(type.description)
                                .font(.system(size: 14, weight: .semibold))
                            
                            Text(
                                locationSearchViewModel
                                    .computeRidePrice(forType: type)
                                    .asCurrencyWith2Decimals()
                            )
                            .font(.system(size: 14, weight: .semibold))
                        }
                        .padding()
                    }
                    .frame(width: 112, height: 140)
                    .foregroundStyle(
                        type == selectedRideType ? .white : Color.theme.primaryText
                    )
                    .background(
                        type == selectedRideType ? Color(.systemBlue) :
                            Color.theme.secondaryBackground
                    )
                    .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedRideType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var paymentOptionView: some View {
        HStack(spacing: 12) {
            Text("VISA")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
                .padding(4)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.vertical)
                .padding(.leading)
            
            Text("**** 1234")
                .bold()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.medium)
                .padding(.trailing)
        }
        .frame(height: 50)
        .background(Color.theme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    private var requestRideButton: some View {
        Button {
            print("confirmed")
        } label: {
            Text("CONFIRM RIDE")
                .bold()
                .padding()
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.white)
        .background(Color(.systemBlue))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}

#Preview {
    RideRequestView()
}
