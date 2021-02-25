//
//  DestinationDashboard.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

struct DestinationDashboard: View {
    struct State: Equatable {
        let placeRows: [[Place]]
    }

    let store: Store<DestinationDashboardState, DestinationDashboardAction>

    var body: some View {
        WithViewStore(store.scope(state: DestinationDashboard.State.init)) { viewStore in
            VStack {
                Button(action: {
                    viewStore.send(.whereToTap)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.73))
                            .frame(maxWidth: .infinity,
                                   minHeight: 60,
                                   maxHeight: 60)

                        HStack {
                            Image(uiImage: #imageLiteral(resourceName: "TaxiCar"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 4.0)
                                .frame(maxWidth: 70)

                            Text("Where to?")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color("WhereToTextColor"))
                            Spacer()
                        }
                    }
                    .padding(8)
                }
                
                ForEach(viewStore.placeRows, id: \.self) { row in
                    HStack {
                        ForEach(row) { place in
                            CommonDestinationView(place: place,
                                                  action: {
                                                      viewStore.send(.pickCommonPlace(place))
                                                  })

                                .padding(4)
                                .frame(maxWidth: 150, maxHeight: 120)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                }

                Spacer()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
            .onAppear {
                // TODO [voro]: send load action whenever location is changed from
                // its default value of (0.0, 0.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewStore.send(.loadCommonDestinations)
                }
            }
        }
    }
}

extension DestinationDashboard.State {
    init(model: DestinationDashboardState) {
        placeRows = Array(model.places.chunked(into: 3).prefix(5))
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct DestinationDashboard_Previews: PreviewProvider {
    static var state: DestinationDashboardState {
        DestinationDashboardState(
            places: [
                Place.banichki,
                Place.banichki,
                Place.banichki,
                Place.banichki
            ],
            region: .init())
    }
    
    static var store: Store<DestinationDashboardState,
                            DestinationDashboardAction> {
        Store(
            initialState: DestinationDashboard_Previews.state,
            reducer: destinationDashboardReducer,
            environment: .mock)
    }

    static var previews: some View {
        Group {
            DestinationDashboard(store: store)
                .preferredColorScheme(.none)
            DestinationDashboard(store: store)
                .preferredColorScheme(.dark)
        }
    }
}
