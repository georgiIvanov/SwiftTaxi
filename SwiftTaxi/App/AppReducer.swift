//
//  AppReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import Foundation

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    struct LocationManagerId: Hashable {}

    switch action {
    case .startUp:
        return environment.locationManager
            .initialisation(LocationManagerId())
            .receive(on: environment.mainQueue)
            .map { switch $0 {
            case .authorizationDidChange(let status):
                return .locationAuthorizationStatusResponse(status)
            } }
            .eraseToEffect()

    case .locationAuthorizationStatusResponse(let status):
        state.locationAuthorizationStatus = status

        switch status {
        case .notDetermined:
            return environment.locationManager
                .requestAuthorization(LocationManagerId())
                .map { AppAction.requestedAuthorization }
                .eraseToEffect()

        case .denied:
            state.alert = .init(
                title: .init(
                    """
                    You denied access to Location. This app needs access to work.
                    """
                )
            )
            return .none

        case .restricted:
            state.alert = .init(title: .init("Your device does not allow speech recognition."))
            return .none

        case .authorizedAlways, .authorizedWhenInUse:
//            state.alert = .init(title: .init("SUCCESS. You are GAME!"))
            return .none

        @unknown default:
            return .none
        }
    case .requestedAuthorization:
        // Logging
        return .none
    case .dismissAuthorizationStateAlert:
        state.alert = nil
        return .none
    case .destinationDashboard(_):
        return .none
    case let .dashboardShown(shown):
        state.dashboardShown = shown
        return .none
    }
}
