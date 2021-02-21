//
//  MapModalView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

enum MapModalAction: Equatable {
    case location(LocationAction)
    case pickPlaceFromMap(Place)
    case closeMap
    case doneButtonTap
}

struct MapModalView: View {
    let store: Store<MapModalViewState, MapModalAction>

    var body: some View {
        GeometryReader { geometry in
            WithViewStore(store) { viewStore in
                ZStack {
                    MapView(
                        store: store.scope(state: \.locationState,
                                           action: { .location($0) })
                    )
                    VStack {
                        HStack {
                            Button {
                                viewStore.send(.closeMap)
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 32))
                                    .padding()
                            }

                            Spacer()
                        }
                        Spacer()

                        Button(action: {
                            viewStore.send(.doneButtonTap)
                        }) {
                            Text("Done")
                                .font(.title3)
                                .bold()
                                .padding([.leading, .trailing],
                                         geometry.size.width * 0.3)
                                .padding([.top, .bottom], 12)
                                .foregroundColor(.black)
                        }
                        .background(Color.yellow)
                        .contentShape(Rectangle())
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(y: -30)
                    }
                }
            }
        }
    }
}

struct MapModalView_Previews: PreviewProvider {
    static var previews: some View {
        MapModalView(store: Store(initialState: MapModalViewState.mock,
                                  reducer: mapModalReducer,
                                  environment: LocationEnvironment.mock))
    }
}
