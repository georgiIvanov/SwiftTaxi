//
//  MapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 19.02.21.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode

    let places: [Place] = [.banichki, .lidl, .mallBulgaria]

    @Binding var region: MKCoordinateRegion

    var body: some View {
        ZStack {
            VStack {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: places,
                    annotationContent: { place in
                        MapMarker(coordinate: place.coordinate, tint: .green)
                    })

                Text("LatitudeDelta: \(region.span.latitudeDelta)")
                Text("LongitudeDelta: \(region.span.longitudeDelta)")
            }
            Image(systemName: "mappin")
                .font(.system(size: 40, weight: .heavy))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(region: .constant(.sofia))
    }
}

extension MKCoordinateRegion {
    static let sofia = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 42.661280062038365,
            longitude: 23.28120068
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
    )
}
