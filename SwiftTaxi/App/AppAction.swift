//
//  AppAction.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import CoreLocation
import Foundation

enum AppAction {
    case destinationDashboard(DestinationDashboardAction)
    case startUp
    case locationAuthorizationStatusResponse(CLAuthorizationStatus)
    case dismissAuthorizationStateAlert
    case requestedAuthorization
    case updateCurrentLocation(location: CLLocationCoordinate2D)
    case updateCurrentLocationName(name: String)
    case locationManagerResponse(Result<LocationManager.Action, LocationManager.Error>)
}
