//
//  ViewModelFactory.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 10.11.2023.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    func makeLocationSearchViewModel() -> LocationSearchViewModel {
        LocationSearchViewModel()
    }
}
