//
//  Location.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation

struct LocationState: Equatable {
    var location = CLLocation()
    var alert: AlertState<AppAction>?
    var map = MapConfig()
    var currentLocationName: String?
    var currentLocation: CLLocationCoordinate2D = .borovo
    var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
}

enum LocationAction: Equatable {
    case startUp
    case locationAuthorizationStatusResponse(CLAuthorizationStatus)
    case updateCurrentLocation(location: CLLocation)
    case updateCurrentLocationName(name: String)
    case locationManagerResponse(Result<LocationManager.Action, LocationManager.Error>)
    case reverseGeocodeLocation(location: CLLocation)
    case dismissAuthorizationStateAlert
}

struct LocationEnvironment {
    var locationManager: LocationManager
    var geoCoder: GeoCoder
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let locationReducer = Reducer<LocationState, LocationAction, LocationEnvironment> {
    state, action, environment in
    struct LocationManagerId: Hashable {}

    switch action {
    case .startUp:
        return environment.locationManager
            .initialisation(LocationManagerId())
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(LocationAction.locationManagerResponse)
            .eraseToEffect()

    case .updateCurrentLocation(let location):
        state.currentLocation = location.coordinate
        state.map.location = location.coordinate

        return .init(value: .reverseGeocodeLocation(location: location))

    case .updateCurrentLocationName(let name):
        state.currentLocationName = name

        return .none

    case .reverseGeocodeLocation(let location):
        return environment.geoCoder
            .lookUpName(location)
            .receive(on: environment.mainQueue)
            .map(LocationAction.updateCurrentLocationName(name:))
            .eraseToEffect()

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
            state.alert = .init(title: .init("Your device does not allow location."))
            return .none

        case .authorizedAlways, .authorizedWhenInUse:
            return environment.locationManager
                .startLocationUpdates(LocationManagerId())
                .fireAndForget()

        @unknown default:
            return .none
        }

    case .dismissAuthorizationStateAlert:
        state.alert = nil
        return .none
    case .locationManagerResponse(let result):
        switch result {
        case .success(let value):
            switch value {
            case .authorizationDidChange(let status):
                return .init(value: .locationAuthorizationStatusResponse(status))
            case .currentLocationDidChange(let location):
                return .init(value: .updateCurrentLocation(location: location))
            }

        case .failure(let error):
            state.alert = .init(title: TextState(verbatim: error.localizedDescription))
            return .none
        }
    }
}
