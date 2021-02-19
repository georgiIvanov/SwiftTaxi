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

    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.locationAuthorizationStatus == rhs.locationAuthorizationStatus &&
            lhs.alert?.id == rhs.alert?.id
    }
}
