//
//  AppAction.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import CoreLocation
import Foundation

enum AppAction: Equatable {
    case pathMap(PathMapAction)
    case location(LocationAction)
    case destinationDashboard(DestinationDashboardAction)
    case destinationPicker(DestinationPickerAction)
    case dashboardShown(Bool)
    case mapModalAction(MapModalAction)
    case showPath(from: Place, to: Place)
}
