//
//  PathMapView.swift
//  SwiftTaxi
//
//  Created by Nikolay Nikolaev Genov on 21.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

struct PathContentView: View {
    let store: Store<PathMapState, PathMapAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            PathMapView(
                region: viewStore.region,
                from: viewStore.from,
                to: viewStore.to,
                polyline: viewStore.polyline
            )
            .ignoresSafeArea()
        }
    }
}

struct PathMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    var region: MKCoordinateRegion
    var from: MKPlacemark
    var to: MKPlacemark
    var polyline: MKPolyline

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        let fromPoint = MKPointAnnotation()
        fromPoint.coordinate = from.coordinate
        fromPoint.title = "From"
        let toPoint = MKPointAnnotation()
        toPoint.coordinate = to.coordinate
        toPoint.title = "To"

        mapView.showAnnotations([fromPoint, toPoint], animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(polyline)
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
        PathContentView(store: Store<PathMapState, PathMapAction>.init(
            initialState: .mock,
            reducer: pathMapReducer,
            environment: .mock)
        )
    }
}
