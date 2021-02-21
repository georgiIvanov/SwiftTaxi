//
//  AppReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import Foundation

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    locationReducer.pullback(state: \AppState.locationState,
                             action: /AppAction.location,
                             environment: {
                                 .init(locationManager: $0.locationManager,
                                       geoCoder: $0.geoCoder,
                                       mainQueue: $0.mainQueue)
                             }),
    contentViewReducer,
    destinationPickerReducer.pullback(state: \AppState.destinationPickerState,
                                      action: /AppAction.destinationPicker,
                                      environment: { .init(
                                          localSearch: $0.localSearch,
                                          mainQueue: $0.mainQueue
                                      )
                                      })
)

let contentViewReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
    switch action {
    case let .destinationPicker(.presentModalMap(present, direction)):
        state.step = present ? .pickModalMap(direction) : .pickDestination(direction)
        return .none
    case .location, .destinationPicker:
        return .none
    case .destinationDashboard(.whereToTap):
        state.step = .pickDestination(.to)
        state.destinationPickerState.selectedLocation = state.locationState.location
        return .none
    case .dashboardShown(let shown):
        state.step = .dashboard(shown ? .large : .medium)
        return .none
    }
}
