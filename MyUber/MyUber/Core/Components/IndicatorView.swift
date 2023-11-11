//
//  IndicatorView.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import SwiftUI

struct IndicatorView: View {
    
    let indicatorSide: CGFloat
    let lineHeight: CGFloat
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color(.systemGray3))
                .frame(width: indicatorSide, height: indicatorSide)
            
            Rectangle()
                .fill(Color(.systemGray3))
                .frame(width: 1, height: lineHeight)
            
            Rectangle()
                .fill(Color.black)
                .frame(width: indicatorSide, height: indicatorSide)
        }
    }
}

#Preview {
    IndicatorView(indicatorSide: 8, lineHeight: 32)
}
