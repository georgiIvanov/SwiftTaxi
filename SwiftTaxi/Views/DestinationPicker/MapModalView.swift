//
//  MapModalView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI
import ComposableArchitecture
import MapKit

struct MapModalViewState {
    var pickLocation: Place
    var direction: Direction
    var location = CLLocation()
}

struct MapModalView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Text("Hello, World!")
            Button("Close") {
                viewStore.send(.destinationDashboard(.whereToTap))
            }
        }
    }
}

struct MapModalView_Previews: PreviewProvider {
    static var previews: some View {
        MapModalView(store: Store(initialState: AppState.mock,
                                  reducer: appReducer,
                                  environment: AppEnvironment.mock))
    }
}
