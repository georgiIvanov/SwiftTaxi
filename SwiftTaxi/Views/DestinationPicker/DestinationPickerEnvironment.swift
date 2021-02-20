//
//  DestinationPickerEnvironment.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Combine
import ComposableArchitecture
import Foundation

struct DestinationPickerEnvironment {
    var localSearch: LocalSearch
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

extension DestinationPickerEnvironment {
    static var mock = {
        DestinationPickerEnvironment(
            localSearch: .mock,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    }()
}
