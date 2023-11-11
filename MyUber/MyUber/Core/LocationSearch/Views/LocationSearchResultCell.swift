//
//  LocationSearchResultCell.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import SwiftUI

struct LocationSearchResultCell: View {
    
    let title: String
    let subTitle: String

    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.blue)
                .tint(Color.white)
                .frame(width: 40)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                Text(subTitle)
                    .font(.callout)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}

#Preview {
    LocationSearchResultCell(title: "Star Bucks", subTitle: "123 Main Street, Cupertino CA")
}
