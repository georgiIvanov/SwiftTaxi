//
//  BottomSheetContainer.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI
import ComposableArchitecture

struct BottomSheetContainer: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            switch viewStore.step {
            case .pickDestination(_):
                DestinationPickerView(
                    store: store.scope(state: \.destinationPickerState,
                                       action: { .destinationPicker($0) }))
            case .dashboard(_):
                DestinationDashboard(
                    store: store.scope(state: \.destinationDashboardState,
                                       action: { .destinationDashboard($0) }))
            case .placeOrder:
                EmptyView()
            case .pickModalMap(_):
                EmptyView()
            }
        }
    }
}

struct BottomSheetContainer_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetContainer(store: Store(initialState: AppState.mock,
                                          reducer: appReducer,
                                          environment: AppEnvironment.mock))
    }
}
