//
//  AppState.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import Foundation

struct AppState: Equatable {
    var destinationDashboardState: DestinationDashboardState = DestinationDashboardState(places: [])
}

extension AppState {
    static var mock = {
        AppState(
            destinationDashboardState: DestinationDashboardState(
                places: [
                    Place(name: "Fu1"),
                    Place(name: "Fu2"),
                    Place(name: "Fu3"),
                    Place(name: "Fu4"),
                ]
            )
        )
    }()
}
