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
        case currentLocationDidChange(CLPlacemark, String)
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

                let geoCoder = CLGeocoder()
                let delegate = LocationManagerDelegate(
                    geoCoder: geoCoder,
                    authorizationStatusDidChange: { status in
                        subscriber.send(.authorizationDidChange(status: status))
                    },
                    currentLocation: { placemark, friendlyName in
                        subscriber.send(.currentLocationDidChange(placemark, friendlyName))
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
                dependencies[id]?.locationManager.requestLocation()
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
    var currentLocation: (CLPlacemark, String) -> Void
    var errorHandler: (Swift.Error) -> Void

    init(geoCoder: CLGeocoder,
         authorizationStatusDidChange: @escaping (CLAuthorizationStatus) -> Void,
         currentLocation: @escaping (CLPlacemark, String) -> Void,
         errorHandler: @escaping (Swift.Error) -> Void) {
        self.geoCoder = geoCoder
        self.authorizationStatusDidChange = authorizationStatusDidChange
        self.currentLocation = currentLocation
        self.errorHandler = errorHandler
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusDidChange(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }

        geoCoder.reverseGeocodeLocation(firstLocation) { [weak self] places, _ in
            guard let firstPlace = places?.first else {
                return
            }

            self?.currentLocation(firstPlace, firstPlace.abbreviation)
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
