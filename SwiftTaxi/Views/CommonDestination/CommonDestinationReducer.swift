//
//  CommonDestinationReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import Foundation
import ComposableArchitecture

let commonDestinationReducer = Reducer<Place, CommonDestinationAction, Void> { state, action, _ in
    switch action {
    case let .setDestination(place):
        print(place)
        return .none
    }
}
