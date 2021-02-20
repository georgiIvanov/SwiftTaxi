//
//  LocationManager.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 19.02.21.
//

import Combine
import ComposableArchitecture
import CoreLocation
import Foundation

struct LocationManager {
    var initialisation: (AnyHashable) -> Effect<Action, Error>
    var requestAuthorization: (AnyHashable) -> Effect<Never, Never>
    var requestSingleLocation: (AnyHashable) -> Effect<Never, Never>

    enum Action: Equatable {
        case authorizationDidChange(status: CLAuthorizationStatus)
        case currentLocationDidChange(CLLocationCoordinate2D)
        case currentLocationNameDidChange(String)
    }

    enum Error: Swift.Error, Equatable {
        case locationError(Swift.Error)

        static func == (lhs: LocationManager.Error, rhs: LocationManager.Error) -> Bool {
            lhs.localizedDescription == rhs.localizedDescription
        }
    }
}

// MARK: - Live

extension LocationManager {
    static let live = LocationManager(
        initialisation: { id in
            Effect.run { subscriber in
                let cancellable = AnyCancellable {
                    dependencies[id] = nil
                }

                let manager = CLLocationManager()

                manager.desiredAccuracy = kCLLocationAccuracyBest

                let geoCoder = CLGeocoder()
                let delegate = LocationManagerDelegate(
                    geoCoder: geoCoder,
                    authorizationStatusDidChange: { status in
                        subscriber.send(.authorizationDidChange(status: status))
                    },
                    currentLocation: { location in
                        subscriber.send(.currentLocationDidChange(location))
                    },
                    currentLocationName: { name in
                        subscriber.send(.currentLocationNameDidChange(name))
                    },
                    errorHandler: { error in
                        subscriber.send(completion: .failure(.locationError(error)))
                    }
                )
                manager.delegate = delegate

                dependencies[id] = LocationDependencies(
                    locationManager: manager,
                    locationManagerDelegate: delegate,
                    geoCoder: geoCoder,
                    subscriber: subscriber
                )

                subscriber.send(.authorizationDidChange(status: manager.authorizationStatus))
                return cancellable
            }
            .cancellable(id: id)
        },
        requestAuthorization: { id in
            .fireAndForget {
                dependencies[id]?.locationManager.requestWhenInUseAuthorization()
            }
        },
        requestSingleLocation: { id in
            .fireAndForget {
                dependencies[id]?.locationManager.startUpdatingLocation()
            }
        }
    )
}

private struct LocationDependencies {
    let locationManager: CLLocationManager
    let locationManagerDelegate: LocationManagerDelegate
    let geoCoder: CLGeocoder
    let subscriber: Effect<LocationManager.Action, LocationManager.Error>.Subscriber
}

private var dependencies: [AnyHashable: LocationDependencies] = [:]

private class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    let geoCoder: CLGeocoder
    var authorizationStatusDidChange: (CLAuthorizationStatus) -> Void
    var currentLocation: (CLLocationCoordinate2D) -> Void
    var currentLocationName: (String) -> Void

    var errorHandler: (Swift.Error) -> Void

    init(geoCoder: CLGeocoder,
         authorizationStatusDidChange: @escaping (CLAuthorizationStatus) -> Void,
         currentLocation: @escaping (CLLocationCoordinate2D) -> Void,
         currentLocationName: @escaping (String) -> Void,
         errorHandler: @escaping (Swift.Error) -> Void) {
        self.geoCoder = geoCoder
        self.authorizationStatusDidChange = authorizationStatusDidChange
        self.currentLocation = currentLocation
        self.currentLocationName = currentLocationName
        self.errorHandler = errorHandler
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusDidChange(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        currentLocation(location.coordinate)

        geoCoder.reverseGeocodeLocation(location) { [weak self] places, _ in

            guard let place = places?.first else {
                return
            }

            self?.currentLocationName(place.abbreviation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorHandler(error)
    }
}

// MARK: - Mock

extension LocationManager {
    static let mock = LocationManager(
        initialisation: { _ in
            .init(value: .authorizationDidChange(status: .denied))
        },
        requestAuthorization: { _ in
            .none
        },
        requestSingleLocation: { _ in
            .none
        }
    )
}

// MARK: - Extensions of CoreLocation

extension CLPlacemark {
    var abbreviation: String {
        if let name = self.name {
            return name
        }

        if let interestingPlace = areasOfInterest?.first {
            return interestingPlace
        }

        return [subThoroughfare, thoroughfare].compactMap { $0 }.joined(separator: " ")
    }
}

extension CLLocationCoordinate2D : Equatable {
    static public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}

