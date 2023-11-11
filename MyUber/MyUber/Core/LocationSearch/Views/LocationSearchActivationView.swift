//
//  LocationSearchActivationView.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 09.11.2023.
//

import SwiftUI

struct LocationSearchActivationView: View {
    
    @Binding var mapState: MapViewState
    
    var body: some View {
        
        if mapState == .noInput {
            HStack {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
                    .padding(.horizontal)
                
                Text("Where to go?")
                    .foregroundStyle(Color(.darkGray))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color.black, radius: 6)
            )
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    LocationSearchActivationView(mapState: .constant(.noInput))
}
