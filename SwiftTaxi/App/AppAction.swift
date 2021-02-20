//
//  AppAction.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import CoreLocation
import Foundation

enum AppAction: Equatable {
    case location(LocationAction)
    case destinationDashboard(DestinationDashboardAction)
    case destinationPicker(DestinationPickerAction)
    case startUp
    case dashboardShown(Bool)
}
