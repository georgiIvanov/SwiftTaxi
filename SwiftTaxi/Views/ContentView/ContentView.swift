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
        self.viewStore = ViewStore(store)
        viewStore.send(.startUp)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MapView(config: viewStore.map)
                    .ignoresSafeArea()
                VStack {
                    Text(viewStore.currentLocationName ?? "Unknown")
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
            .alert(self.store.scope(state: { $0.alert }), dismiss: .dismissAuthorizationStateAlert)
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
