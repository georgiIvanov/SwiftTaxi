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
    var alert: AlertState<AppAction>?
    var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
    var destinationDashboardState: DestinationDashboardState = DestinationDashboardState(places: [])
    var dashboardShown: Bool
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
                    Place.mallBulgaria,
                ]
            ),
            dashboardShown: false
        )
    }()
    
}
