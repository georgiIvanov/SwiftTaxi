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
        switch state.lastEditing {
        case .to:
            state.toPlace = place
            break
        case .from:
            state.fromPlace = place
            break
        case .none:
            print("No text field was previously selected, but place is picked, is it to or from?")
            break
        }
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
    case .editing(.some(.to)):
        state.lastEditing = .to
        return .none
    case .editing(.some(.from)):
        state.lastEditing = .from
        return .none
    case .editing(.none):
        print("no editing")
        return .none
    }
}
