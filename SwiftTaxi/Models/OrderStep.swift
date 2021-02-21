//
//  OrderStep.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation

enum OrderStep: Equatable {
    case dashboard(ModalSize)
    case pickDestination(Direction)
    case pickModalMap(Direction)
    case placeOrder
}

extension OrderStep {
    var isDashboardExpanded: Bool {
        switch self {
        case .dashboard(.large), .pickDestination(_), .pickModalMap(_):
            return true
        default:
            return false
        }
    }
    
    var isModalMapPresented: Bool {
        switch self {
        case .pickModalMap(_):
            return true
        default:
            return false
        }
    }

    var isShowPathPresented: Bool {
        switch self {
        case .placeOrder:
            return true
        default:
            return false
        }
    }
}
