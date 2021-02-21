//
//  OrderView.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import SwiftUI
import ComposableArchitecture
import MapKit

enum OrderAction: Equatable {
    case placeOrder
}

struct OrderView: View {
    
    let store: Store<OrderState, OrderAction>
    let distanceFormatter = MKDistanceFormatter()
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    func calcularePrice(distance: CLLocationDistance, pricePerUnit: Double) -> String {
        let price = distance / 1000 * pricePerUnit
        let number = NSNumber(value: price)
        return numberFormatter.string(from: number) ?? "Unknown"
    }
    
    var body: some View {
        
        WithViewStore(store) { viewStore in
            GeometryReader(content: { geometry in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From: \(viewStore.from.name)")
                                .padding(4)
                            Text("To: \(viewStore.to.name)")
                                .padding(4)
                        }
                        .padding(4)
                        Spacer()
                    }
                    HStack {
                        Text("Distance: \(distanceFormatter.string(fromDistance: viewStore.route.distance))")
                        Divider()
                            .frame(maxHeight: 20)
                        Text("Expected Price: \(calcularePrice(distance: viewStore.route.distance, pricePerUnit: 2.5))")
                        Spacer()
                    }
                    .padding(.leading, 16)
                    
                    HStack {
                        Spacer()
                        Button(action:  {
                            
                        }) {
                            Text("Order")
                                .padding([.leading, .trailing],
                                         geometry.size.width * 0.3)
                                .padding([.top, .bottom], 20)
                                .foregroundColor(.black)
                        }
                        .background(Color.yellow)
                        .contentShape(Rectangle())
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .offset(y: 4)
                        Spacer()
                    }
                }
                
            })
            .background(Color.offWhite)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(store: Store(initialState: OrderState(), reducer: orderViewReducer, environment: ()))
    }
}
