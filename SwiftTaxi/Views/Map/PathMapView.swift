//
//  PathMapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 21.02.21.
//

import MapKit
import SwiftUI

struct PathContentView: View {
    @State private var from = MKPlacemark(coordinate: Place.banichki.coordinate)
    @State private var to = MKPlacemark(coordinate: Place.mallBulgaria.coordinate)
    @State private var region = MKCoordinateRegion()
    @State private var polyline = MKPolyline()

    private let pathFinder = PathFinder()

    var body: some View {
        VStack {
            Button("Calculate route") {
                pathFinder.findPath { route in
                    polyline = route.polyline
                }
            }
            PathMapView(region: $region,
                        polyline: $polyline,
                        from: $from,
                        to: $to)
        }
    }
}

struct PathMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @Binding var region: MKCoordinateRegion
    @Binding var polyline: MKPolyline
    @Binding var from: MKPlacemark
    @Binding var to: MKPlacemark

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        mapView.setRegion(region, animated: true)
        mapView.showAnnotations([from, to], animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showAnnotations([from, to], animated: true)
        uiView.addOverlay(polyline)
        uiView.setVisibleMapRect(
            polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            animated: true)
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct PathContentView_Previews: PreviewProvider {
    static var previews: some View {
        PathContentView()
    }
}
