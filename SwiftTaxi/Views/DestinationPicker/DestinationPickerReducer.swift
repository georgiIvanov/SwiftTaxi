//
//  DestinationPickerReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import ComposableArchitecture
import Foundation

let destinationPickerReducer = Reducer<DestinationPickerState, DestinationPickerAction, DestinationPickerEnvironment> {
        state, action, environment in
    switch action {
    case .destinationPick(let place):
        return .none
    case .toTextChanged(let newText):
        state.to = newText
        return .init(value: .localSearch(newText))
    case .fromTextChanged(let newText):
        state.from = newText
        return .init(value: .localSearch(newText))
    case .searchResponse(let places):
        state.searchResult = places
        return .none
    case .pickFromMap:
        return .none
    case .localSearch(let searchTerm):
        return environment.localSearch
            .search(state.selectedRegion, searchTerm)
            .receive(on: environment.mainQueue)
            .map {
                .searchResponse($0.map { item in
                    Place(name: item.name ?? item.placemark.abbreviation,
                          latitude: item.placemark.coordinate.latitude,
                          longitude: item.placemark.coordinate.longitude)
                })
            }
            .eraseToEffect()
    }
}
