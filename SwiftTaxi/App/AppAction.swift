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
}
