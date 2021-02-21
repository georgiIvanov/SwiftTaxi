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
    var geoCoder: GeoCoder
    var localSearch: LocalSearch
    var pathFinder: PathFinder
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
    static var live = AppEnvironment(locationManager: .live,
                                     geoCoder: .live,
                                     localSearch: .live,
                                     pathFinder: .live,
                                     mainQueue: DispatchQueue.main.eraseToAnyScheduler())

    static var mock = AppEnvironment(locationManager: .mock,
                                     geoCoder: .mock,
                                     localSearch: .mock,
                                     pathFinder: .mock,
                                     mainQueue: DispatchQueue.main.eraseToAnyScheduler())
}
