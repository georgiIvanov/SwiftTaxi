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
        case .none:
            print("No text field was previously selected, but place is picked, is it to or from?")
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
    case .editing(.some(.to)):
        state.lastEditing = .to
        return .none
    case .editing(.some(.from)):
        state.lastEditing = .from
        return .none
    case .editing(.none):
        print("no editing")
        return .none
    case .localSearch(let searchTerm):
        return environment.localSearch
            .search(state.selectedRegion, searchTerm)
            .debounce(id: LocalSearchId(), for: 0.3, scheduler: environment.mainQueue)
            .receive(on: environment.mainQueue)
            .map { .searchResponse($0.flatMap(Place.getBothPlaces)) }
            .eraseToEffect()
    case let .presentModalMap(present):
        state.isModalMapPresented = present
        return .none
    }
}
