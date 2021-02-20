//
//  DestinationPickerView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI
import ComposableArchitecture

enum DestinationPickerAction: Equatable {
    case fromTextChanged(String)
    case toTextChanged(String)
    case searchResponse([Place])
    case destinationPick(Place)
    case pickFromMap
}

struct DestinationPickerState: Equatable {
    var from: String = ""
    var to: String = ""
    
    var fromPlace: Place = Place(name: "fu1", latitude: 1, longitude: 1)
    var toPlace: Place = Place(name: "fu2", latitude: 1, longitude: 1)
    
    var searchResult: [Place] = []
}

struct DestinationPickerView: View {
    
    let store: Store<DestinationPickerState, DestinationPickerAction>
    
    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                VStack {
                    HStack {
                        Image(systemName: "circle")
                        TextField("",
                                  text: viewStore.binding(get: { $0.from },
                                                          send: DestinationPickerAction.fromTextChanged)
                        )
                        .frame(minHeight: 50)
                        .background(Color.green)
                    }
                    .frame(maxWidth: geometry.size.width * 0.9)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("",
                                  text: viewStore.binding(get: { $0.to },
                                                          send: DestinationPickerAction.toTextChanged)
                        )
                        .frame(minHeight: 50)
                        .background(Color.green)
                        Divider()
                            .frame(width: 1, height: 50, alignment: .center)
                        Button("Map") {
                            viewStore.send(.pickFromMap)
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.9)
                    
                    
                    List {
                        ForEach(viewStore.searchResult) { place in
                            Text("\(place.name)")
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
                                           environment: DestinationPickerEnvironment.mock ))
    }
}
