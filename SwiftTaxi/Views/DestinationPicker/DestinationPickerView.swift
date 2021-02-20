//
//  DestinationPickerView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

enum DestinationPickerAction: Equatable {
    case fromTextChanged(String)
    case toTextChanged(String)
    case searchResponse([Place])
    case destinationPick(Place)
    case pickFromMap
    case localSearch(String)
}

struct DestinationPickerState: Equatable {
    var selectedRegion: MKCoordinateRegion {
        let commonDelta: CLLocationDegrees = 25 / 111
        let span = MKCoordinateSpan(
            latitudeDelta: commonDelta,
            longitudeDelta: commonDelta)
        return MKCoordinateRegion(center: selectedLocation.coordinate,
                                  span: span)
    }

    var selectedLocation = CLLocation()
    var from: String = ""
    var to: String = ""

    var fromPlace = Place(name: "fu1", latitude: 1, longitude: 1)
    var toPlace = Place(name: "fu2", latitude: 1, longitude: 1)

    var searchResult: [Place] = []
}

struct DestinationPickerView: View {
    let store: Store<DestinationPickerState, DestinationPickerAction>

    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                VStack {
                    SearchTextField(text: viewStore.binding(get: { $0.from },
                                                            send: DestinationPickerAction.fromTextChanged),
                                    content: { EmptyView() }, systemImage: "circle")
                        .frame(maxWidth: geometry.size.width * 0.9)

                    SearchTextField(text: viewStore.binding(get: { $0.to },
                                                            send: DestinationPickerAction.toTextChanged),
                                    content: {
                                        Button("Map") {
                                            viewStore.send(.pickFromMap)
                                        }
                                    }, systemImage: "magnifyingglass")
                        .frame(maxWidth: geometry.size.width * 0.9)

                    List {
                        ForEach(viewStore.searchResult) { place in
                            Text("\(place.name)")
                        }
                    }
                }
            }
        }
    }
}

struct DestinationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationPickerView(store: Store(initialState: DestinationPickerState(),
                                           reducer: destinationPickerReducer,
                                           environment: DestinationPickerEnvironment.mock))
    }
}
