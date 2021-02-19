//
//  DestinationDashboard.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import SwiftUI
import ComposableArchitecture

struct DestinationDashboardState: Equatable {
    let places: [Place]
}

enum DestinationDashboardAction {
    case whereToTap
}

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
                        .fill(Color.blue)
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
                        Spacer()
                    }
                    
                    
                }
                .padding(8)
                
                ForEach(viewStore.placeRows, id: \.self) { (row) in
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
            .background(Color.gray)
        }
    }
}

extension DestinationDashboard.State {
    init(model: DestinationDashboardState) {
        var rows = [[Place]]()
        var places = model.places
        for _ in 0..<2 {
            let row = Array(places.prefix(3))
            rows.append(row)
            places = Array(places.dropFirst(3))
        }
        
        placeRows = rows
    }
}

struct DestinationDashboard_Previews: PreviewProvider {
    
    static var state: DestinationDashboardState {
        DestinationDashboardState(
            places: [
                Place.banichki,
                Place.banichki,
                Place.banichki,
                Place.banichki,
            ])
    }
    
    static var previews: some View {
        DestinationDashboard(
            store: Store<DestinationDashboardState,
                         DestinationDashboardAction>(
                initialState: DestinationDashboard_Previews.state,
                reducer: destinationDashboardReducer,
                environment: ()))
    }
}
