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
            .catchToEffect()
            .map(AppAction.locationManagerResponse)
            .eraseToEffect()

    case .updateCurrentLocation(let placemark, let name):
        state.currentPlacemark = placemark
        state.currentLocationName = name
        state.alert = .init(title: .init("SUCCESS. You are at \(name)!"))

        return .none
    case .locationAuthorizationStatusResponse(let status):
        state.locationAuthorizationStatus = status

        switch status {
        case .notDetermined:
            return environment.locationManager
                .requestAuthorization(LocationManagerId())
                .fireAndForget()

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
            return environment.locationManager
                .requestSingleLocation(LocationManagerId())
                .fireAndForget()

        @unknown default:
            return .none
        }
    case .requestedAuthorization:
        // Logging
        return .none
    case .dismissAuthorizationStateAlert:
        state.alert = nil
        return .none
    case .destinationDashboard:
        return .none
    case .locationManagerResponse(let result):
        switch result {
        case .success(let value):
            switch value {
            case .authorizationDidChange(let status):
                return .init(value: .locationAuthorizationStatusResponse(status))
            case .currentLocationDidChange(let placemark, let friendlyName):
                return .init(value: .updateCurrentLocation(placemark: placemark, name: friendlyName))
            }
        case .failure(let error):
            state.alert = .init(title: TextState(verbatim: error.localizedDescription))
            return .none
        }
    }
}
