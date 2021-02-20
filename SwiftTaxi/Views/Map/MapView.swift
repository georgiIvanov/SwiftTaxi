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
                    coordinateRegion: viewStore.binding(get: \.region, send: { .regionUpdated($0) }),
                    showsUserLocation: true,
                    annotationItems: places,
                    annotationContent: { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            let ratio = CGFloat(viewStore.region.span.latitudeDelta)
                            let size: CGFloat = ratio < 0.02 ? 50 : (1.0 / ratio)
                            if size > 25 {
                                Image(uiImage: #imageLiteral(resourceName: "TaxiCar"))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size,
                                           height: size)
                            }
                        }
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

extension CLLocation {
    static let borovo = CLLocation(latitude: 42.66128006,
                                   longitude: 23.28120068)
}
