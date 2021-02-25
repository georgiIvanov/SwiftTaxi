//
//  OrderView.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import ComposableArchitecture
import MapKit
import SwiftUI

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
                    VStack {
                        HStack {
                            Text("From: \(viewStore.from.name)")
                                .padding(4)
                            Divider()
                            Text("To: \(viewStore.to.name)")
                                .padding(4)
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        HStack {
                            Text("Distance: \(distanceFormatter.string(fromDistance: viewStore.route.distance))")
                            Divider()
                                .frame(maxHeight: 20)
                            Text("Expected Price: \(calcularePrice(distance: viewStore.route.distance, pricePerUnit: 2.5))")
                            Spacer()
                        }.fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    
                    CallToActionButton(text: "Order") {

                    }
                }

            })
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(16)
        }
    }
}

struct CallToActionButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.title3)
                .bold()
                .padding([.leading, .trailing], 120)
                .padding([.top, .bottom], 12)
                .foregroundColor(.black)
        }
        .background(Color.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderView(store: Store(initialState: OrderState(), reducer: orderViewReducer, environment: ()))
        }
    }
}
