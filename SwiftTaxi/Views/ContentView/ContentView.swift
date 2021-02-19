//
//  ContentView.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        ZStack {
            // Map Here
            Rectangle()
                .fill(Color.green)
            
            VStack {
                Spacer()
                DestinationDashboard(
                    store: store.scope(state: { $0.destinationDashboardState },
                                       action: { .destinationDashboard($0) }
                    )
                )
                .frame(maxHeight: 300)
            }
            .ignoresSafeArea()
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
