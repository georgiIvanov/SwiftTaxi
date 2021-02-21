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
    var from = MKPlacemark(coordinate: .init()) // Weird behaviour if empty
    var to = MKPlacemark(coordinate: .init())
}

enum PathMapAction: Equatable {
    case findPath
    case pathFound(MKRoute)
}

struct PathMapEnvironment {
    var pathFinder: PathFinder
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let pathMapReducer = Reducer<PathMapState, PathMapAction, PathMapEnvironment> {
    state, action, environment in

    switch action {
    case .findPath:
        return environment.pathFinder
            .findPath(state.from, state.to)
            .map(PathMapAction.pathFound)
            .eraseToEffect()
    case .pathFound(let route):
        state.polyline = route.polyline
        return .none
    }
}

// MARK: - Mock

extension PathMapState {
    static let mock = PathMapState()
}

extension PathMapEnvironment {
    static var mock = PathMapEnvironment(
        pathFinder: .mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
