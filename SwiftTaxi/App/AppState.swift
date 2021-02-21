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
    var destinationDashboardState = DestinationDashboardState(places: [])
    var destinationPickerState = DestinationPickerState()
    
    var mapModalState: MapModalViewState {
        get {
            MapModalViewState(
                pickLocation: destinationPickerState.currentPickingPlace,
                direction: destinationPickerState.lastEditing,
                locationState: locationState)
        }
        
        set {
            destinationPickerState.setPlace(newValue.pickLocation,
                                            forDirection: newValue.direction)
        }
    }
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
