//
//  DestinationPickerEnvironment.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation
import ComposableArchitecture
import Combine

struct DestinationPickerEnvironment {
    var searchPlaces: ((String) -> Effect<DestinationPickerAction, Never>)
}

extension DestinationPickerEnvironment {
    static var mock = {
        DestinationPickerEnvironment(searchPlaces: { searchText in
            Effect(Just(DestinationPickerAction.searchResponse(Array([
                Place(name: "asd1", latitude: 1, longitude: 1),
                Place(name: "asd2", latitude: 2, longitude: 2),
                Place(name: "asd3", latitude: 3, longitude: 3),
                Place(name: "asd4", latitude: 4, longitude: 4),
            ].prefix(Int.random(in: 0...4))))))
        })
    }()
}
