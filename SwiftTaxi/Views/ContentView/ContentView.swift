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

    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    MapView(
                        store: store.scope(state: { $0.locationState },
                                           action: { .location($0) })
                    )

                    VStack {
                        BottomSheetView(
                            isOpen: viewStore.binding(get: { $0.dashboardShown },
                                                      send: { .dashboardShown($0) }),
                            maxHeight: geometry.size.height
                        ) {
                            if viewStore.pickDestination {
                                DestinationPickerView(
                                    store: store.scope(state: { $0.destinationPickerState },
                                                       action: { .destinationPicker($0) }))
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
            }
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
