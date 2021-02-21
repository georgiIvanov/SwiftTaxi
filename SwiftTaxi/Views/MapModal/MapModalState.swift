//
//  MapModalState.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import Foundation

struct MapModalViewState: Equatable {
    var pickLocation: Place = .banichki
    var direction: Direction = .to
    var locationState = LocationState()
}

extension MapModalViewState {
    static var mock = {
        MapModalViewState(
            pickLocation: .banichki,
            direction: .to,
            locationState: LocationState.mock)
    }()
}
