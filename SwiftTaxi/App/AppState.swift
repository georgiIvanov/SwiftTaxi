//
//  AppState.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation

struct AppState: Equatable {
    var locationState = LocationState()
    var dashboardShown: Bool = false
    var pickDestination: Bool = false
    var destinationDashboardState = DestinationDashboardState(places: [])
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
