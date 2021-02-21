//
//  AppReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import Foundation
import MapKit

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    contentViewReducer,
    locationReducer.pullback(state: \AppState.locationState,
                             action: /AppAction.location,
                             environment: {
                                 .init(locationManager: $0.locationManager,
                                       geoCoder: $0.geoCoder,
                                       mainQueue: $0.mainQueue)
                             }),
    destinationPickerReducer.pullback(state: \AppState.destinationPickerState,
                                      action: /AppAction.destinationPicker,
                                      environment: { .init(
                                          localSearch: $0.localSearch,
                                          mainQueue: $0.mainQueue
                                      )
                                      }),
    mapModalReducer.pullback(state: \AppState.mapModalState,
                             action: /AppAction.mapModalAction,
                             environment: {
                                 .init(locationManager: $0.locationManager,
                                       geoCoder: $0.geoCoder,
                                       mainQueue: $0.mainQueue)
                             }),
    pathMapReducer.pullback(state: \AppState.pathMapState,
                            action: /AppAction.pathMap,
                            environment: { .init(
                                pathFinder: $0.pathFinder,
                                mainQueue: $0.mainQueue
                            )
                            }),
    destinationDashboardReducer.pullback(state: \AppState.destinationDashboardState,
                                         action: /AppAction.destinationDashboard,
                                         environment: {
                                             .init(
                                                 localSearch: $0.localSearch,
                                                 mainQueue: $0.mainQueue
                                             )
                                         })
)

let contentViewReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
    switch action {
    case .destinationDashboard(.pickCommonPlace(let place)):
        state.step = .placeOrder
        return .init(value: .showPath(from: state.locationState.locationPlace!,
                                      to: place))
    case .showPath(let from, let to):
        state.pathMapState.region = state.locationState.region
        state.pathMapState.from = .init(coordinate: from.coordinate)
        state.pathMapState.to = .init(coordinate: to.coordinate)
        return .init(value: .pathMap(.findPath))
    case .destinationPicker(.presentModalMap(let present, let direction)):
        state.step = present ? .pickModalMap(direction) : .pickDestination(direction)
        state.mapModalState = MapModalViewState(
            pickLocation: Place(location: state.locationState.location),
            direction: direction,
            locationState: state.locationState)
        return .none
    case .destinationDashboard(.whereToTap):
        state.step = .pickDestination(.to)
        state.destinationPickerState.selectedLocation = state.locationState.location
        if let initialFrom = state.locationState.locationPlace {
            state.destinationPickerState.from = initialFrom.name
            state.destinationPickerState.fromPlace = initialFrom
        }
        return .none
    case .dashboardShown(let shown):
        state.step = .dashboard(shown ? .large : .medium)
        return .none
    case .mapModalAction(.closeMap):
        state.step = .pickDestination(state.mapModalState.direction)
        return .none
    case .mapModalAction(.pickPlaceFromMap(let place)):
        state.destinationPickerState.setPlace(place, forDirection: state.destinationPickerState.lastEditing)
        if state.destinationPickerState.pickedBothPlaces {
            state.step = .placeOrder
            return .init(value: .showPath(from: state.destinationPickerState.fromPlace,
                                          to: state.destinationPickerState.toPlace))
        } else {
            state.step = .pickDestination(state.mapModalState.direction)
            return .none
        }
    case .destinationPicker(.pickedBothDestinations):
        state.step = .placeOrder
        return .init(value: .showPath(from: state.destinationPickerState.fromPlace,
                                      to: state.destinationPickerState.toPlace))

    case .location, .destinationPicker, .pathMap, .mapModalAction, .destinationDashboard:
        return .none
    }
}
