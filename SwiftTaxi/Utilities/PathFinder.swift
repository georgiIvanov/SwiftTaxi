//
//  PathFinder.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import Foundation
import MapKit

struct PathFinder {
    var findPath: (_ source: MKPlacemark, _ destination: MKPlacemark) -> Effect<MKRoute, Never>
}

extension PathFinder {
    static let live = PathFinder(
        findPath: { source, destination in
            .future { callback in
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: source)
                request.destination = MKMapItem(placemark: destination)
                request.transportType = .automobile

                let directions = MKDirections(request: request)

                directions.calculate { response, _ in
                    guard let route = response?.routes.first else {
                        return
                    }

                    callback(.success(route))
                }
            }
        }
    )
}

// MARK: - Mock

extension PathFinder {
    static let mock = PathFinder(
        findPath: { _, _ in
            .init(value: .init())
        }
    )
}

// struct PathFinder {
//    func findPath(completion: @escaping (MKRoute) -> Void) {
//        let source = MKMapItem(placemark: .init(coordinate: Place.banichki.coordinate))
//        let destination = MKMapItem(placemark: .init(coordinate: Place.mallBulgaria.coordinate))
//
//        let request = MKDirections.Request()
//
//        request.source = source
//        request.destination = destination
//        request.transportType = .automobile
//
//        let directions = MKDirections(request: request)
//
//        directions.calculate { response, _ in
//            guard let route = response?.routes.first else {
//                return
//            }
//
//            completion(route)
//        }
//    }
// }
