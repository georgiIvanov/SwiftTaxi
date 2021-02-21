//
//  DestinationDashboardReducer.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import Foundation
import MapKit

struct DestinationDashboardState: Equatable {
    var places = [Place]()
    var region = MKCoordinateRegion()
}

enum DestinationDashboardAction: Equatable {
    case whereToTap
    case loadCommonDestinations
    case populatePlaces([Place])
}

struct DestinationDashboardEnvironment {
    var localSearch: LocalSearch
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let destinationDashboardReducer = Reducer<
    DestinationDashboardState,
    DestinationDashboardAction,
    DestinationDashboardEnvironment> { state, action, environment in
    switch action {
    case .whereToTap:
        return .none
    case .loadCommonDestinations:
        return environment.localSearch
            .interestingPlaces(state.region)
            .receive(on: environment.mainQueue)
            .map { DestinationDashboardAction.populatePlaces($0.map(Place.init)) }
            .eraseToEffect()
    case .populatePlaces(let places):
        state.places = places
        return .none
    }
}

// MARK: - Mock

extension DestinationDashboardEnvironment {
    static let mock = DestinationDashboardEnvironment(
        localSearch: .mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
}
