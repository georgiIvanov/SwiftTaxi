//
//  GeoCoder.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation

struct GeoCoder {
    var lookUpName: (CLLocation) -> Effect<String, Never>
    var lookUpPlace: (CLLocation) -> Effect<Place, Never>
}

extension GeoCoder {
    static let live = GeoCoder(
        lookUpName: { location in
            geocodeLookup(location)
                .map{ $0.abbreviation }
        },
        lookUpPlace: { location in
            GeoCoder.geocodeLookup(location)
                .map(Place.init)
                .compactMap{$0}
                .eraseToEffect()
        }
    )
    
    private static var geocodeLookup: (CLLocation) -> Effect<CLPlacemark, Never> = { location in
        .future { callback in
            CLGeocoder().reverseGeocodeLocation(location) { places, _ in
                guard let place = places?.first else { return }
                callback(.success(place))
            }
        }
    }
}

extension GeoCoder {
    static let mock = GeoCoder(
        lookUpName: { _ in
            .init(value: "Over the rainbow")
        },
        lookUpPlace: { _ in
            .init(value: .banichki)
        }
    )
}
