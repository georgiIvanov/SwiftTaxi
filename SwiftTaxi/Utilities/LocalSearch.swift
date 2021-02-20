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
}

extension LocalSearch {
    static let live = LocalSearch(
        search: { region, text in
            .future { callback in

                let request = MKLocalSearch.Request()
                request.region = region
                request.naturalLanguageQuery = text

                let localSearch = MKLocalSearch(request: request)
                localSearch.start { response, error in
                    //TODO[ngenov]: Make that return errors again
//                    if let error = error {
//                        callback(.failure(error))
//                    }
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
        }
    )
}
