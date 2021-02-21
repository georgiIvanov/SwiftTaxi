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
                        Spacer()
                    }
                }
                .padding(8)
                .onTapGesture {
                    viewStore.send(.whereToTap)
                }

                ForEach(viewStore.placeRows, id: \.self) { row in
                    HStack {
                        ForEach(row) { place in
                            CommonDestinationView(store: Store(initialState: place,
                                                               reducer: commonDestinationReducer,
                                                               environment: ()))
                                .padding(4)
                                .frame(maxWidth: 150, maxHeight: 120)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                }

                Spacer()
            }
            .background(Color.offWhite)
            .cornerRadius(16)
            .onAppear {
                viewStore.send(.loadCommonDestinations)
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

    static var previews: some View {
        DestinationDashboard(
            store: Store<DestinationDashboardState,
                DestinationDashboardAction>(
                initialState: DestinationDashboard_Previews.state,
                reducer: destinationDashboardReducer,
                environment: .mock))
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}
