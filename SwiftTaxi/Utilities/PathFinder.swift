//
//  PathFinder.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import Foundation
import MapKit

struct PathFinder {
    func findPath(completion: @escaping (MKRoute) -> Void) {
        let source = MKMapItem(placemark: .init(coordinate: Place.banichki.coordinate))
        let destination = MKMapItem(placemark: .init(coordinate: Place.mallBulgaria.coordinate))

        let request = MKDirections.Request()

        request.source = source
        request.destination = destination
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { response, _ in
            guard let route = response?.routes.first else {
                return
            }

            completion(route)
        }
    }
}
