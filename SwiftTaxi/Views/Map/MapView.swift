//
//  MapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 19.02.21.
//

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var config: MapConfig

    let places: [Place] = [.banichki, .lidl, .mallBulgaria]

    var body: some View {
        ZStack {
            Map(coordinateRegion: $config.region,
                showsUserLocation: true,
                annotationItems: places,
                annotationContent: { place in
                    MapMarker(coordinate: place.coordinate, tint: .green)
                })

            HStack {
                Spacer()
                Button(action: { config.moveToCurrentLocation() }) {
                    Image(systemName: "location.circle")
                        .font(.system(size: 32))
                        .padding()
                }
            }

            Image(systemName: "mappin")
                .font(.system(size: 40, weight: .heavy))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(config: MapConfig())
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
