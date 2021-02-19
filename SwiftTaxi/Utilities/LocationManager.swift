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
    var initialisation: (AnyHashable) -> Effect<Action, Never>
    var requestAuthorization: (AnyHashable) -> Effect<Void, Never>

    enum Action: Equatable {
        case authorizationDidChange(status: CLAuthorizationStatus)
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

                let delegate = LocationManagerDelegate(
                    authorizationStatusDidChange: { status in
                        subscriber.send(.authorizationDidChange(status: status))
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
        }
    )
}

private struct LocationDependencies {
    let locationManager: CLLocationManager
    let locationManagerDelegate: LocationManagerDelegate
    let subscriber: Effect<LocationManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: LocationDependencies] = [:]

private class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var authorizationStatusDidChange: (CLAuthorizationStatus) -> Void

    init(authorizationStatusDidChange: @escaping (CLAuthorizationStatus) -> Void) {
        self.authorizationStatusDidChange = authorizationStatusDidChange
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusDidChange(status)
    }
}

// MARK: - Mock

extension LocationManager {
    static let mock = LocationManager(
        initialisation: { _ in
            .init(value: .authorizationDidChange(status: .denied))
        },
        requestAuthorization: { _ in
            .init(value: ())
        }
    )
}
