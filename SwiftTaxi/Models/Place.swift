//
//  Place.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import CoreLocation
import Foundation

struct Place: Identifiable, Equatable, Hashable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Place {
    static let banichki = Place(name: "Banichki",
                                latitude: 42.678750656166784,
                                longitude: 23.28562151394663)
    static let lidl = Place(name: "Lidl",
                            latitude: 42.67029470660005,
                            longitude: 23.2785190240458)
    static let mallBulgaria = Place(name: "Mall bulgaria",
                                    latitude: 42.66382544465565,
                                    longitude: 23.288910046317582)
}
