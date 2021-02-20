//
//  MapConfig.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation
import MapKit

final class MapConfig: ObservableObject {
    private var firstUpdate = true

    var location = CLLocationCoordinate2D() {
        didSet {
            if firstUpdate {
                region.center = location
                region.span = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                firstUpdate = false
            }
        }
    }

    func moveToCurrentLocation() {
        region.center = location
    }

    @Published var region = MKCoordinateRegion() {
        didSet {
            print("Lat: \(region.center.latitude) Lon: \(region.center.longitude)")
        }
    }
}

extension MapConfig: Equatable {
    static func == (lhs: MapConfig, rhs: MapConfig) -> Bool {
        return lhs.location == rhs.location && lhs.region.center == rhs.region.center &&
            lhs.region.span.latitudeDelta == rhs.region.span.latitudeDelta &&
            lhs.region.span.longitudeDelta == rhs.region.span.longitudeDelta
    }
}
