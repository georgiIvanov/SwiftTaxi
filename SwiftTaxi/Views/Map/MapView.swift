//
//  MapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 19.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

struct MapView: View {
    let places: [Place] = [.banichki, .lidl, .mallBulgaria]

    let store: Store<LocationState, LocationAction>
    var body: some View {
        WithViewStore(store) { viewStore in

            ZStack {
                Map(
                    coordinateRegion: viewStore.binding(
                        get: { $0.region },
                        send: { .regionUpdated($0) }
                    ),
                    showsUserLocation: true,
                    annotationItems: places,
                    annotationContent: { place in
                        MapMarker(coordinate: place.coordinate, tint: .green)
                    }
                )
                .ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewStore.send(.resetLocationToCurrentLocation)
                        }) {
                            Image(systemName: "location.circle")
                                .font(.system(size: 32))
                                .padding()
                        }
                    }
                    Spacer()
                }
                VStack {
                    Text(viewStore.locationName ?? "Unknown")
                        .padding()
                        .background(Color.white)

                    Spacer()
                }
                Image(systemName: "mappin")
                    .font(.system(size: 40, weight: .heavy))
            }
            .alert(self.store.scope(state: { $0.alert }),
                   dismiss: .dismissAuthorizationStateAlert)
            .onAppear {
                viewStore.send(.startUp)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(store: Store<LocationState, LocationAction>.init(initialState: .mock,
                                                                 reducer: locationReducer,
                                                                 environment: .mock))
    }
}

extension CLLocationCoordinate2D {
    static let borovo = CLLocationCoordinate2D(
        latitude: 42.661280062038365,
        longitude: 23.28120068
    )
    static let current = CLLocationCoordinate2D(
        latitude: 42.667,
        longitude: 23.28120068
    )
}

extension CLLocation {
    static let borovo = CLLocation(latitude: CLLocationCoordinate2D.borovo.latitude,
                                   longitude: CLLocationCoordinate2D.borovo.longitude)
}
