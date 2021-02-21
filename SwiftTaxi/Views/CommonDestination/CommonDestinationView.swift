//
//  CommonDestinationView.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import ComposableArchitecture
import SwiftUI

enum CommonDestinationAction {
    case setDestination(Place)
}

struct CommonDestinationView: View {
    let store: Store<Place, CommonDestinationAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.name)
                    .font(.caption)
                    .bold()
                    .lineLimit(nil)
                    .padding(.top, 8.0)
                    .padding([.leading, .trailing], 4.0)
                Spacer()
                HStack {
                    Image(systemName: "car")
                        .padding(8)
                    Spacer()
                    Image(systemName: "mappin.and.ellipse")
                        .padding(8)
                }
            }.padding(0)
                .background(Color.blue.opacity(0.33))
                .cornerRadius(12)
                .onTapGesture {
                    viewStore.send(.setDestination(viewStore.state))
                }
        }
    }
}

struct CommonDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        CommonDestinationView(store: Store(initialState: .mallBulgaria,
                                           reducer: commonDestinationReducer,
                                           environment: ()))
            .previewLayout(.sizeThatFits)
    }
}
