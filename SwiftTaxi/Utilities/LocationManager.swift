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
    var startLocationUpdates: (AnyHashable) -> Effect<Never, Never>

    enum Action: Equatable {
        case authorizationDidChange(status: CLAuthorizationStatus)
        case currentLocationDidChange(CLLocation)
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
                    authorizationStatusDidChange: { status in
                        subscriber.send(.authorizationDidChange(status: status))
                    },
                    currentLocation: { location in
                        subscriber.send(.currentLocationDidChange(location))
                    },
                    errorHandler: { error in
                        subscriber.send(completion: .failure(.locationError(error)))
                    }
                )
                manager.delegate = delegate

                dependencies[id] = LocationDependencies(
                    locationManager: manager,
                    locationManagerDelegate: delegate,
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
        startLocationUpdates: { id in
            .fireAndForget {
                dependencies[id]?.locationManager.startUpdatingLocation()
            }
        }
    )
}

private struct LocationDependencies {
    let locationManager: CLLocationManager
    let locationManagerDelegate: LocationManagerDelegate
    let subscriber: Effect<LocationManager.Action, LocationManager.Error>.Subscriber
}

private var dependencies: [AnyHashable: LocationDependencies] = [:]

private class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var authorizationStatusDidChange: (CLAuthorizationStatus) -> Void
    var currentLocation: (CLLocation) -> Void
    var errorHandler: (Swift.Error) -> Void

    init(authorizationStatusDidChange: @escaping (CLAuthorizationStatus) -> Void,
         currentLocation: @escaping (CLLocation) -> Void,
         errorHandler: @escaping (Swift.Error) -> Void) {
        self.authorizationStatusDidChange = authorizationStatusDidChange
        self.currentLocation = currentLocation
        self.errorHandler = errorHandler
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusDidChange(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        currentLocation(location)
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
        startLocationUpdates: { _ in
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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}
