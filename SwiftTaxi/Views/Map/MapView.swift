//
//  MapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 19.02.21.
//

import MapKit
import SwiftUI

struct Place: Identifiable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode

    let places = [
        Place(name: "Banichki", latitude: 42.678750656166784, longitude: 23.28562151394663),
        Place(name: "Lidl",
              latitude: 42.67029470660005,
              longitude: 23.2785190240458),
        Place(name: "Mall bulgaria", latitude: 42.66382544465565, longitude: 23.288910046317582)
    ]

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
