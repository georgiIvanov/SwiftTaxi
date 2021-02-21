//
//  AppState.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation
import MapKit

struct AppState: Equatable {
    var locationState = LocationState()
    var step: OrderStep = .dashboard(.medium)
    var destinationDashboardState = DestinationDashboardState()
    var destinationPickerState = DestinationPickerState()
    var mapModalState = MapModalViewState()
    var pathMapState = PathMapState()
    var orderState = OrderState()
}

extension AppState {
    static var mock = {
        AppState(
            destinationDashboardState: DestinationDashboardState(
                places: [
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria,
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria,
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria
                ]
            )
        )
    }()
}
