//
//  AppState.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import CoreLocation
import Foundation
import MapKit

final class MapConfig: ObservableObject {
    private var firstUpdate = true

    var location = CLLocationCoordinate2D() {
        didSet {
            if firstUpdate {
                region.center = location
                region.span = .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                firstUpdate = false
            }
        }
    }

    func moveToCurrentLocation() {
        region.center = location
    }

    @Published var region = MKCoordinateRegion() {
        didSet {
            print("Lat: \(region.center.latitude) Lon: \(region.center.longitude)")
        }
    }
}

struct AppState: Equatable {
    var map = MapConfig()
    var alert: AlertState<AppAction>?
    var currentLocationName: String?
    var currentLocation: CLLocationCoordinate2D = .borovo
    var locationAuthorizationStatus = CLAuthorizationStatus.notDetermined
    var destinationDashboardState = DestinationDashboardState(places: [])
}

extension AppState {
    static var mock = {
        AppState(
            destinationDashboardState: DestinationDashboardState(
                places: [
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria,
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria,
                    Place.banichki,
                    Place.lidl,
                    Place.mallBulgaria
                ]
            )
        )
    }()
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    lhs.locationAuthorizationStatus == rhs.locationAuthorizationStatus &&
        lhs.alert?.id == rhs.alert?.id
}
