//
//  ContentView.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

struct ContentView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        viewStore = ViewStore(store)
        viewStore.send(.startUp)
    }

    @State var region = MKCoordinateRegion.sofia
    var body: some View {
        ZStack {
            MapView(region: $region)
                .ignoresSafeArea()

            VStack {
                Spacer()
                DestinationDashboard()
                    .frame(maxHeight: 300)
            }
            .ignoresSafeArea()
        }
        .alert(self.store.scope(state: { $0.alert }), dismiss: .dismissAuthorizationStateAlert)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(),
                                 reducer: appReducer,
                                 environment: .mock))
    }
}
