//
//  OrderState.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import Foundation
import MapKit

struct OrderState: Equatable {
    var to: Place = .empty
    var from: Place = .empty
    var route: MKRoute = MKRoute()
}
