//
//  Location.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation
import MapKit

struct LocationState: Equatable {
    var initialLocationLoaded = false
    var location = CLLocation()
    var locationPlace: Place?
    var userCurrentLocation = CLLocation()
    var alert: AlertState<LocationAction>?
    var region = MKCoordinateRegion()
    var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
}

enum LocationAction: Equatable {
    case startUp
    case locationAuthorizationStatusResponse(CLAuthorizationStatus)
    case updateCurrentLocation(CLLocation)
    case locationLookupResponse(Place?)
    case locationManagerResponse(Result<LocationManager.Action, LocationManager.Error>)
    case reverseGeocodeLocation(CLLocation)
    case dismissAuthorizationStateAlert
    case regionUpdated(MKCoordinateRegion)
    case resetLocationToCurrentLocation
    case updateLocation(CLLocation)
    case updateViewPortLocation(CLLocation)
}

struct LocationEnvironment {
    var locationManager: LocationManager
    var geoCoder: GeoCoder
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let locationReducer = Reducer<LocationState, LocationAction, LocationEnvironment> {
    state, action, environment in
    struct LocationManagerId: Hashable {}
    struct GeoCoderId: Hashable {}

    switch action {
    case .updateViewPortLocation(let location):
        state.region.center = location.coordinate
        state.region.span = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        return .none

    case .resetLocationToCurrentLocation:
        let location = state.userCurrentLocation
        return Effect.merge(
            .init(value: .updateLocation(location)),
            .init(value: .updateViewPortLocation(location))
        )

    case .regionUpdated(let region):
        state.region = region
        return .init(value: .updateLocation(.init(latitude: region.center.latitude,
                                                  longitude: region.center.longitude)))

    case .startUp:
        return environment.locationManager
            .initialisation(LocationManagerId())
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(LocationAction.locationManagerResponse)
            .eraseToEffect()

    case .updateCurrentLocation(let location):
        state.userCurrentLocation = location
        if !state.initialLocationLoaded {
            state.initialLocationLoaded = true
            return Effect.merge(
                .init(value: .updateLocation(location)),
                .init(value: .updateViewPortLocation(location))
            )
        }
        return .none

    case .updateLocation(let location):
        let c = location.coordinate
        print(String(format: "Lat: %.5f Lon: %.5f", c.latitude, c.longitude))
        state.location = location

        return .init(value: .reverseGeocodeLocation(location))

    case .locationLookupResponse(let place):
        state.locationPlace = place
        return .none

    case .reverseGeocodeLocation(let location):
        return environment.geoCoder
            .lookUpLocation(location)
            .map(Place.init)
            .debounce(id: GeoCoderId(), for: 0.3, scheduler: environment.mainQueue)
            .receive(on: environment.mainQueue)
            .map(LocationAction.locationLookupResponse)
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
                return .init(value: .updateCurrentLocation(location))
            }

        case .failure(let error):
            state.alert = .init(title: TextState(verbatim: error.localizedDescription))
            return .none
        }
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center &&
            lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
            lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

// MARK: - Mock

extension LocationState {
    static let mock = LocationState(
        location: .borovo,
        locationPlace: .borovo,
        userCurrentLocation: .borovo,
        alert: nil,
        locationAuthorizationStatus: CLAuthorizationStatus.authorizedAlways
    )
}

extension LocationEnvironment {
    static var mock = LocationEnvironment(locationManager: .mock,
                                          geoCoder: .mock,
                                          mainQueue: DispatchQueue.main.eraseToAnyScheduler())
}
