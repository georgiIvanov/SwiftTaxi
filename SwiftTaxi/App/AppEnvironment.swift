//
//  AppEnvironment.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import Foundation

struct AppEnvironment {
    var locationManager: LocationManager
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
    static var live = AppEnvironment(locationManager: .live,
                                     mainQueue: DispatchQueue.main.eraseToAnyScheduler())

    static var mock = AppEnvironment(locationManager: .mock,
                                     mainQueue: DispatchQueue.main.eraseToAnyScheduler())
}
