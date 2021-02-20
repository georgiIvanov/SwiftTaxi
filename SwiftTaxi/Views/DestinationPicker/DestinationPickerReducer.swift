//
//  DestinationPickerReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation
import ComposableArchitecture

let destinationPickerReducer = Reducer<DestinationPickerState, DestinationPickerAction, Void> { state, action, _ in
    switch action {
    case let .destinationPick(place):
        return .none
    case let .fromPlaceTextChanged(newText):
        return .none
    case let .toPlaceTextChanged(newText):
        return .none
    }
}
