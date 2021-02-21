//
//  Place.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import CoreLocation
import Foundation
import MapKit

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
    static func getBothPlaces(_ item: MKMapItem) -> [Place] {
        let placemark = item.placemark
        let coordinate = placemark.coordinate
        let placeWithName = item.name.flatMap { Place(name: $0, coordinate: coordinate) }
        let placeWithAddress = Place(name: placemark.abbreviation, coordinate: coordinate)
        if let placeWithName = placeWithName {
            if placeWithName.name == placeWithAddress.name {
                return [placeWithName]
            } else {
                return [placeWithName, placeWithAddress]
            }
        } else {
            return [placeWithAddress]
        }
    }

    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.init(name: name,
                  latitude: coordinate.latitude,
                  longitude: coordinate.longitude)
    }
    
    init?(_ placemark: CLPlacemark) {
        guard let location = placemark.location else {
            print("Could not create Place with placemark:\n\(placemark)")
            return nil
        }
        
        let name = placemark.name ?? placemark.abbreviation
        self.init(name: name, coordinate: location.coordinate)
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
