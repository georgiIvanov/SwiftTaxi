//
//  DestinationPickerReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation
import ComposableArchitecture

let destinationPickerReducer = Reducer<DestinationPickerState,
                                       DestinationPickerAction,
                                       DestinationPickerEnvironment> { state, action, environment in
    switch action {
    case let .destinationPick(place):
        return .none
    case let .toTextChanged(newText):
        state.to = newText
        return environment.searchPlaces(newText)
    case let .fromTextChanged(newText):
        state.from = newText
        return environment.searchPlaces(newText)
    case let .searchResponse(places):
        state.searchResult = places
        return .none
    case .pickFromMap:
        return .none
    }
}
