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
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                ZStack {
                    MapView(
                        store: store.scope(state: \.locationState,
                                           action: { .location($0) })
                    )
                    
                    VStack {
                        BottomSheetView(
                            isOpen: viewStore.binding(get: \.dashboardShown,
                                                      send: { .dashboardShown($0) }),
                            maxHeight: geometry.size.height
                        ) {
                            if viewStore.pickDestination {
                                DestinationPickerView(
                                    store: store.scope(state: \.destinationPickerState,
                                                       action: { .destinationPicker($0) }))
                            } else {
                                DestinationDashboard(
                                    store: store.scope(state: \.destinationDashboardState,
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
