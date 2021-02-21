//
//  MapModalReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import Foundation
import ComposableArchitecture


let mapModalReducer = Reducer<MapModalViewState, MapModalAction, LocationEnvironment>.combine(
    locationReducer.pullback(state: \.locationState,
                             action: /MapModalAction.location,
                             environment: {
                                .init(locationManager: $0.locationManager,
                                      geoCoder: $0.geoCoder,
                                      mainQueue: $0.mainQueue)
                            }),
    mapModalViewReducer
)
    
    
private let mapModalViewReducer = Reducer<MapModalViewState, MapModalAction, LocationEnvironment> { state, action, env in
    switch action {
    case let .location(.locationLookupResponse(.some(place))):
        state.pickLocation = place
        return .none
    case .doneButtonTap:
        return .init(value: .pickPlaceFromMap(state.pickLocation))
    case .location,
         .pickPlaceFromMap,
         .closeMap:
        return .none
    }
}

