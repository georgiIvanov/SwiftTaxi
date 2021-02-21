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
            VStack {
                Button("Calculate route") {
                    viewStore.send(.findPath)
                }

                PathMapView(region: viewStore.binding(get: \.region,
                                                      send: { _ in .devnull }),
                            polyline: viewStore.binding(get: \.polyline,
                                                        send: { _ in .devnull }),
                            from: viewStore.binding(get: \.from,
                                                    send: { _ in .devnull }),
                            to: viewStore.binding(get: \.to,
                                                  send: { _ in .devnull }))
            }
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
        PathContentView(store: Store<PathMapState, PathMapAction>.init(
            initialState: .mock,
            reducer: pathMapReducer,
            environment: .mock)
        )
    }
}
