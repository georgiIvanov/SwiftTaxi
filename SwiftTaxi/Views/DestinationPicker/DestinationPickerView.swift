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
    case fromTextChanged(String)
    case toTextChanged(String)
    case searchResponse([Place])
    case destinationPick(Place)
    case pickFromMap
    case editing(Direction)
    case localSearch(String)
    case presentModalMap(Bool, Direction)
}

struct DestinationPickerView: View {
    
    let store: Store<DestinationPickerState, DestinationPickerAction>

    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                VStack {
                    SearchTextField(
                        placeholder: "From:",
                        isEditing: viewStore.binding(get: {_ in false },
                                                     send: { _ in DestinationPickerAction.editing(.from)
                                                     }),
                        text: viewStore.binding(get: { $0.from },
                                                send: DestinationPickerAction.fromTextChanged),
                        content: { EmptyView() }, systemImage: "circle")
                        .frame(maxWidth: geometry.size.width * 0.9)
                    
                    SearchTextField(
                        placeholder: "To:",
                        isEditing: viewStore.binding(get: {_ in false },
                                                     send: { _ in DestinationPickerAction.editing(.to)
                                                     }),
                        text: viewStore.binding(get: { $0.to },
                                                send: DestinationPickerAction.toTextChanged),
                        content: {
                            Button("Map") {
                                viewStore.send(.presentModalMap(true, viewStore.lastEditing))
                            }
                        }, systemImage: "magnifyingglass")
                        .frame(maxWidth: geometry.size.width * 0.9)
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
}

struct DestinationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationPickerView(store: Store(initialState: DestinationPickerState(),
                                           reducer: destinationPickerReducer,
                                           environment: DestinationPickerEnvironment.mock))
    }
}
