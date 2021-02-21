//
//  GeoCoder.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation
import MapKit
import Intents
import Contacts

struct GeoCoder {
    var lookUpLocation: (CLLocation) -> Effect<CLPlacemark, Never>
}

extension GeoCoder {
    static let live = GeoCoder(
        lookUpLocation: { location in
            geocodeLookup(location)
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

class MockPlacemark: CLPlacemark {
}

extension GeoCoder {
    static let mock = GeoCoder(
        lookUpLocation: { _ in
            let placemark = MockPlacemark(location: CLLocation(), name: "Over the rainbow", postalAddress: nil)
            return .init(value: placemark)
        }
    )
}
