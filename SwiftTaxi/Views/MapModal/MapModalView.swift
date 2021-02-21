//
//  MapModalView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI
import ComposableArchitecture
import MapKit

enum MapModalAction: Equatable {
    case location(LocationAction)
    case closeMap
}

struct MapModalView: View {
    
    let store: Store<MapModalViewState, MapModalAction>
    
    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                ZStack {
                    MapView(
                        store: store.scope(state: \.locationState,
                                           action: { .location($0) })
                    )
                    Button("Close") {
                        viewStore.send(.closeMap)
                    }
                }
            }
        }
    }
}

struct MapModalView_Previews: PreviewProvider {
    static var previews: some View {
        MapModalView(store: Store(initialState: MapModalViewState.mock,
                                  reducer: mapModalReducer,
                                  environment: LocationEnvironment.mock))
    }
}
