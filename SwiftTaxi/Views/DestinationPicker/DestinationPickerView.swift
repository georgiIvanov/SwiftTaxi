//
//  DestinationPickerView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI
import ComposableArchitecture

enum DestinationPickerAction: Equatable {
    case fromPlaceTextChanged(String)
    case toPlaceTextChanged(String)
    case destinationPick(Place)
}

struct DestinationPickerState: Equatable {
    let from: Place = Place(name: "fu1", latitude: 1, longitude: 1)
    let to: Place = Place(name: "fu2", latitude: 1, longitude: 1)
    
    let searchResult: [Place] = []
}

struct DestinationPickerView: View {
    
    let store: Store<DestinationPickerState, DestinationPickerAction>
    
    let filterResult = [Place(name: "fu1", latitude: 1, longitude: 1),
                        Place(name: "fu2", latitude: 1, longitude: 1),
                        Place(name: "fu3", latitude: 1, longitude: 1),
                        Place(name: "fu4", latitude: 1, longitude: 1),]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                TextField("",
                          text: viewStore.binding(get: { $0.from.name },
                                                  send: DestinationPickerAction.fromPlaceTextChanged)
                )
                TextField("",
                          text: viewStore.binding(get: { $0.to.name },
                                                  send: DestinationPickerAction.toPlaceTextChanged)
                )
                List {
                    ForEach(filterResult) { place in
                        Text("\(place.name)")
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
                                           environment: ()))
    }
}
