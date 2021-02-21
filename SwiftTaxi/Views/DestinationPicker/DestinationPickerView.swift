//
//  DestinationPickerView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import ComposableArchitecture
import SwiftUI

enum Direction: Equatable {
    case from
    case to
}

enum DestinationPickerAction: Equatable {
    case textChanged(String, Direction)
    case searchResponse([Place])
    case destinationPick(Place)
    case pickFromMap
    case editing(Direction)
    case localSearch(String)
    case presentModalMap(Bool, Direction)
    case pickedBothDestinations
}

struct DestinationPickerView: View {
    let store: Store<DestinationPickerState, DestinationPickerAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                VStack {
                    SearchTextField(
                        viewStore: viewStore,
                        direction: .from,
                        text: viewStore.binding(get: { $0.from },
                                                send: { DestinationPickerAction.textChanged($0, .from) })
                    )
                    .padding(.bottom, 8)

                    SearchTextField(
                        viewStore: viewStore,
                        direction: .to,
                        text: viewStore.binding(get: { $0.to },
                                                send: { DestinationPickerAction.textChanged($0, .to) })
                    )
                }
                .padding()

                List {
                    ForEach(viewStore.searchResult) { place in
                        Button(place.name) {
                            viewStore.send(.destinationPick(place))
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
