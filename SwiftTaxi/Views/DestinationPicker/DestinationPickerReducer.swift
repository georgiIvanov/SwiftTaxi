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
    
    struct LocalSearchId: Hashable {}
    
    switch action {
    case let .destinationPick(place):
        switch state.lastEditing {
        case .to:
            state.toPlace = place
            break
        case .from:
            state.fromPlace = place
            break
        }
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
    case .editing(.to):
        state.lastEditing = .to
        return .none
    case .editing(.from):
        state.lastEditing = .from
        return .none
    case .localSearch(let searchTerm):
        return environment.localSearch
            .search(state.selectedRegion, searchTerm)
            .debounce(id: LocalSearchId(), for: 0.3, scheduler: environment.mainQueue)
            .receive(on: environment.mainQueue)
            .map { .searchResponse($0.flatMap(Place.getBothPlaces)) }
            .eraseToEffect()
    case .presentModalMap(_, _):
        return .none
    }
}
