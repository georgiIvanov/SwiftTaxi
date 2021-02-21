//
//  PathMap.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 21.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation
import MapKit

struct PathMapState: Equatable {
    var polyline = MKPolyline()
    var region = MKCoordinateRegion()
    var from = MKPlacemark(coordinate: Place.banichki.coordinate)
    var to = MKPlacemark(coordinate: Place.mallBulgaria.coordinate)
}

enum PathMapAction: Equatable {
    case findPath
    case pathFound(MKRoute)
    case devnull
}

struct PathMapEnvironment {
    var pathFinder: PathFinder
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let pathMapReducer = Reducer<PathMapState, PathMapAction, PathMapEnvironment> {
    state, action, environment in

    switch action {
    case .devnull:
        return .none
    case .findPath:
        return environment.pathFinder
            .findPath(state.from, state.to)
            .map(PathMapAction.pathFound)
            .eraseToEffect()
    case .pathFound(let route):
        print(route)
        state.polyline = route.polyline
        return .none
    }
}

// MARK: - Mock

extension PathMapState {
    static let mock = PathMapState(
    )
}

extension PathMapEnvironment {
    static var mock = PathMapEnvironment(
        pathFinder: .mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
