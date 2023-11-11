//
//  MyUberApp.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 09.11.2023.
//

import SwiftUI

@main
struct MyUberApp: App {
    
    @StateObject private var locationSearchViewModel = LocationSearchViewModel()
    
    init() {
        UICollectionView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationSearchViewModel)
        }
    }
}
