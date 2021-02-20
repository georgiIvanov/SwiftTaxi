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
    var map = MapConfig()
    var alert: AlertState<AppAction>?
    var currentLocationName: String?
    var currentLocation: CLLocationCoordinate2D = .borovo
    var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
    var dashboardShown: Bool = false
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
