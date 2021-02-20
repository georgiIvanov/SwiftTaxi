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
}

extension GeoCoder {
    static let live = GeoCoder(
        lookUpName: { location in
            .future { callback in
                CLGeocoder().reverseGeocodeLocation(location) { places, _ in
                    guard let place = places?.first else { return }
                    callback(.success(place.abbreviation))
                }
            }
        }
    )
}

extension GeoCoder {
    static let mock = GeoCoder(
        lookUpName: { _ in
            .init(value: "Over the rainbow")
        }
    )
}
