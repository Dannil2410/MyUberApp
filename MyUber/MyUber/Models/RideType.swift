//
//  RideType.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 11.11.2023.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable {
    case uberX
    case black
    case uberXL
    
    var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .uberX: return "UberX"
        case .black: return "UberBlack"
        case .uberXL: return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .black: return 20
        case .uberXL: return 10
        }
    }
    
    func computePrice(forDistanceinMeters distanceInMeters: Double) -> Double {
        let distanceInKM = distanceInMeters / 1000
        switch self {
        case .uberX: return distanceInKM * 1.5 + baseFare
        case .black: return distanceInKM * 2.0 + baseFare
        case .uberXL: return distanceInKM * 1.75 + baseFare
        }
    }
}
