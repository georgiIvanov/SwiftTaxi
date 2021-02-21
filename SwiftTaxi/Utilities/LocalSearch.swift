//
//  LocalSearch.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 20.02.21.
//

import ComposableArchitecture
import Foundation
import MapKit

struct LocalSearch {
    var search: (MKCoordinateRegion, String) -> Effect<[MKMapItem], Never>
    var interestingPlaces: (MKCoordinateRegion) -> Effect<[MKMapItem], Never>
}

extension LocalSearch {
    static let live = LocalSearch(
        search: { region, text in
            .future { callback in

                let request = MKLocalSearch.Request()
                request.region = region
                request.naturalLanguageQuery = text

                let localSearch = MKLocalSearch(request: request)
                localSearch.start { response, _ in
                    let items = response?.mapItems ?? []
                    callback(.success(items))
                }
            }
        },
        interestingPlaces: { region in
            .future { callback in
                let request = MKLocalSearch.Request()
                request.region = region
                request.pointOfInterestFilter = .init(including: [.airport, .zoo, .hotel, .nightlife])

                let localSearch = MKLocalSearch(request: request)
                localSearch.start { response, _ in
                    let items = response?.mapItems ?? []
                    callback(.success(items))
                }
            }
        }
    )
}

extension LocalSearch {
    static let mock = LocalSearch(
        search: { _, _ in
            .init(value: [.init()])
        },
        interestingPlaces: { _ in
            .init(value: [])
        }
    )
}
