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

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MapView(config: viewStore.locationState.map)
                    .ignoresSafeArea()
                VStack {
                    Text(viewStore.locationState.currentLocationName ?? "Unknown")
                        .padding()
                        .background(Color.white)

                    Spacer()
                }
                VStack {
                    BottomSheetView(
                        isOpen: viewStore.binding(get: { $0.dashboardShown },
                                                  send: { .dashboardShown($0) }),
                        maxHeight: geometry.size.height
                    ) {
                        if viewStore.pickDestination {
                            DestinationPickerView()
                        } else {
                            DestinationDashboard(
                                store: store.scope(state: { $0.destinationDashboardState },
                                                   action: { .destinationDashboard($0) }
                                )
                            )
                        }
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .alert(self.store.scope(state: { $0.locationState.alert }), dismiss: .location(.dismissAuthorizationStateAlert))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState.mock,
                                 reducer: appReducer,
                                 environment: .mock))
    }
}
