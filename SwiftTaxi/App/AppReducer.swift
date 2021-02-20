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
                                      environment: { _ in DestinationPickerEnvironment.mock })
)

let contentViewReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
    switch action {
    case .location(let action):
        return .none
    case .destinationDashboard(.whereToTap):
        state.dashboardShown = true
        state.pickDestination = true
        return .none
    case .destinationPicker(_):
        return .none
    case .dashboardShown(let shown):
        state.dashboardShown = shown
        if shown == false {
            state.pickDestination = false
        }
        return .none
    }
}
